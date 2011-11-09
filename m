Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab1KIMmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:42:54 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56328 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab1KIMmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:42:53 -0500
Message-ID: <4EBA7544.5030403@linaro.org>
Date: Wed, 09 Nov 2011 20:42:44 +0800
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20111010 Icedove/3.1.15
MIME-Version: 1.0
To: ashish.jangam@kpitcummins.com
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linaro-dev@lists.linaro.org, lrg@slimlogic.co.uk,
        linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>
Subject: Re: [Patch 5/11] Regulator: DA9052/53 regulator support v5
References: <1318950455.4644.65.camel@L-0761.kpit.com> <1320740905.5640.3.camel@L-0761.kpit.com>
In-Reply-To: <1320740905.5640.3.camel@L-0761.kpit.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011年11月08日 16:28), ashishj3 wrote:
> On Tue, 2011-10-18 at 20:37 +0530, ashishj3 wrote: 
>> The Dialog PMIC has below featured regulators:-
>> DA9052-BC - 4 DVS Buck converters 0.5V - 3.6V upto 1Amp.
>> DA9053-AA/BX - 4 DVS Buck converters 0.5V - 2.5V upto 3Amp.
>> DA9052/53 - 10 Programmable LDO's High PSSR, 1% accuracy.
>>
>> This patch support all the DA9052 and Da9053 regulators. The output voltages are
>> fully programmable via I2C or SPI interface. The platform data with regulation
>> constraints is passed down from the board to the regulator.
>>
>> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
>> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
>> Tested-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
>>
>> CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
>> ---
> If there are no review commnets then can it get ACK?
> 
> 
Tested-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>

Thanks Ashish.

Hi Mark,

I've already tested this driver (v5) with the DA9052 MFD v8 driver
posted on 20111103. It is tested on my imx53 Quickstart board. This
patch also looks good to me. Please review this driver if possible.

Many Thanks,
Paul
