Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab2IKJiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 05:38:01 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:58498 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756781Ab2IKJh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 05:37:59 -0400
Message-ID: <504EFE6D.3090901@stericsson.com>
Date: Tue, 11 Sep 2012 11:03:41 +0200
From: Ola Lilja <ola.o.lilja@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Roger NILSSON1 <roger.xr.nilsson@stericsson.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 05/17] ASoC: Ux500: Minor coding layout changes
References: <1345816913-4113-1-git-send-email-lee.jones@linaro.org> <1345816913-4113-6-git-send-email-lee.jones@linaro.org> <20120910164448.GD24506@gmail.com>
In-Reply-To: <20120910164448.GD24506@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 06:44 PM, Lee Jones wrote:

> Ola poke.
> 
> On Fri, Aug 24, 2012 at 03:01:41PM +0100, Lee Jones wrote:
>> Includes removal of duplicate debug print affirming entry into
>> the probe function, an unnecessary line break of a coding line
>> <80 chars and a white space change (unintentional tab).
>> 
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> ---
>>  sound/soc/ux500/mop500.c |    7 ++-----
>>  1 file changed, 2 insertions(+), 5 deletions(-)
>> 
>> diff --git a/sound/soc/ux500/mop500.c b/sound/soc/ux500/mop500.c
>> index 6840df7..356611d 100644
>> --- a/sound/soc/ux500/mop500.c
>> +++ b/sound/soc/ux500/mop500.c
>> @@ -88,8 +88,6 @@ static int __devinit mop500_probe(struct platform_device *pdev)
>>  	struct device_node *np = pdev->dev.of_node;
>>  	int ret;
>>  
>> -	pr_debug("%s: Enter.\n", __func__);
>> -
>>  	dev_dbg(&pdev->dev, "%s: Enter.\n", __func__);
>>  
>>  	mop500_card.dev = &pdev->dev;
>> @@ -117,8 +115,7 @@ static int __devinit mop500_probe(struct platform_device *pdev)
>>  	ret = snd_soc_register_card(&mop500_card);
>>  	if (ret)
>>  		dev_err(&pdev->dev,
>> -			"Error: snd_soc_register_card failed (%d)!\n",
>> -			ret);
>> +			"Error: snd_soc_register_card failed (%d)!\n", ret);
>>  
>>  	return ret;
>>  }
>> @@ -131,7 +128,7 @@ static int __devexit mop500_remove(struct platform_device *pdev)
>>  
>>  	snd_soc_unregister_card(mop500_card);
>>  	mop500_ab8500_remove(mop500_card);
>> -	
>> +
>>  	return 0;
>>  }
>>  
>> -- 
>> 1.7.9.5
>> 
> 


Nothing to say about this one. Looks OK.

