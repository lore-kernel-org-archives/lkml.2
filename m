Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab2KLQW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:22:28 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59753 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab2KLQW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:22:26 -0500
MIME-Version: 1.0
In-Reply-To: <20121004112623.GL4360@opensource.wolfsonmicro.com>
References: <1349320509-26930-1-git-send-email-festevam@gmail.com>
	<20121004112623.GL4360@opensource.wolfsonmicro.com>
Date: Mon, 12 Nov 2012 14:22:26 -0200
Message-ID: <CAOMZO5Bc+CfRdDPA5ABm93=Tq-OKPPHhSinAw2x=Vv1zf9YROQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] mfd: da9052-core: Use regmap_irq_get_virq() and fix
 the probe
From: Fabio Estevam <festevam@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, sameo@linux.intel.com
Cc: ashish.jangam@kpitcummins.com, dchen@diasemi.com, arnd@arndb.de,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Thu, Oct 4, 2012 at 8:26 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Oct 04, 2012 at 12:15:04AM -0300, Fabio Estevam wrote:
>> From: Fabio Estevam <fabio.estevam@freescale.com>
>>
>> On a mx53qsb dt-kernel the da9052-core driver fails to probe as follows:
>>
>> da9052 1-0048: DA9052 ADC IRQ failed ret=-22
>>
>> The reason for the error was due to passing only the offset as the interrupt
>> number in request_threaded_irq() without da9052->irq_base.
>
> Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Could this series be applied, please?

Thanks,

Fabio Estevam
