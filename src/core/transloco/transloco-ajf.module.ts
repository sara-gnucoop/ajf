/**
 * @license
 * Copyright (C) Gnucoop soc. coop.
 *
 * This file is part of the Advanced JSON forms (ajf).
 *
 * Advanced JSON forms (ajf) is free software: you can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * Advanced JSON forms (ajf) is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero
 * General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with Advanced JSON forms (ajf).
 * If not, see http://www.gnu.org/licenses/.
 *
 */

import {NgModule} from '@angular/core';
import {
  TRANSLOCO_CONFIG,
  TRANSLOCO_LOADER,
  TRANSLOCO_MISSING_HANDLER,
  translocoConfig,
  TranslocoModule
} from '@ngneat/transloco';

import {TranslocoHttpLoader} from './transloco-loader';
import {MissingHandler} from './transloco-missing-handler';


@NgModule({
  exports: [TranslocoModule],
  providers: [
    {
      provide: TRANSLOCO_CONFIG,
      useValue: translocoConfig({
        availableLangs: ['en', 'es', 'fr', 'it'],
        defaultLang: 'en',
        reRenderOnLangChange: true,
        prodMode: false,
      })
    },
    {provide: TRANSLOCO_LOADER, useClass: TranslocoHttpLoader},
    {provide: TRANSLOCO_MISSING_HANDLER, useClass: MissingHandler}
  ],
})
export class AjfTranslocoModule {
}