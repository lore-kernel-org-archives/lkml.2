Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030331Ab2KWJvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:51:19 -0500
Received: from antcom.de ([188.40.178.216]:35935 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030282Ab2KWJvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:51:17 -0500
Message-ID: <50AF4711.9040708@antcom.de>
Date: Fri, 23 Nov 2012 10:51:13 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.9) Gecko/20121015 Icedove/10.0.9
MIME-Version: 1.0
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: Alban Bedel <alban.bedel@avionic-design.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] pwm: lpc32xx - Set the chip base for dynamic allocation
References: <1352894295-14339-1-git-send-email-alban.bedel@avionic-design.de> <1352894295-14339-4-git-send-email-alban.bedel@avionic-design.de> <CAAAP30E6aFbeLq3uf8t2oiepaqouFRWtTt=Uc+TRir36acNKSA@mail.gmail.com>
In-Reply-To: <CAAAP30E6aFbeLq3uf8t2oiepaqouFRWtTt=Uc+TRir36acNKSA@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2012 10:35 AM, Alexandre Pereira da Silva wrote:
> On Wed, Nov 14, 2012 at 9:58 AM, Alban Bedel
> <alban.bedel@avionic-design.de> wrote:
>> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> 
> Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Acked-by: Roland Stigge <stigge@antcom.de>

> 
>> ---
>>  drivers/pwm/pwm-lpc32xx.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
>> index f45ce2c..3e63689 100644
>> --- a/drivers/pwm/pwm-lpc32xx.c
>> +++ b/drivers/pwm/pwm-lpc32xx.c
>> @@ -121,6 +121,7 @@ static int lpc32xx_pwm_probe(struct platform_device *pdev)
>>         lpc32xx->chip.dev = &pdev->dev;
>>         lpc32xx->chip.ops = &lpc32xx_pwm_ops;
>>         lpc32xx->chip.npwm = 2;
>> +       lpc32xx->chip.base = -1;
>>
>>         ret = pwmchip_add(&lpc32xx->chip);
>>         if (ret < 0) {
>> --
>> 1.7.0.4
>>

