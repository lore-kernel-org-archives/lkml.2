Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab0FOFhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 01:37:04 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65113 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab0FOFhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 01:37:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZMrxAlJGYV6F3IS9pK6H8WeyafA8V9nhLzAGRhp5Yp96J5WWmsyFEZ/QvF3JQ6jre9
         hbw2hvhsOj4GVnpJtMeFlLOr0HwVHXQfyBNVqvzvdNWOLX780/4MsjKb7dwUmYPEkSu0
         ACmGCAQpHcM4/WhS2vYOV1EtxLPm3p+dIuPU0=
Message-ID: <4C171189.3060303@gmail.com>
Date: Mon, 14 Jun 2010 22:37:13 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
       debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
       linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 8/8]tuners:tuner-simple Fix warning: variable 'tun' set
 but not used
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-9-git-send-email-justinmattock@gmail.com> <4C170CA4.2020805@redhat.com>
In-Reply-To: <4C170CA4.2020805@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 10:16 PM, Mauro Carvalho Chehab wrote:
>
>
> Em 14-06-2010 23:26, Justin P. Mattock escreveu:
>> not sure if this is correct or not for
>> fixing this warning:
>>    CC [M]  drivers/media/common/tuners/tuner-simple.o
>> drivers/media/common/tuners/tuner-simple.c: In function 'simple_set_tv_freq':
>> drivers/media/common/tuners/tuner-simple.c:548:20: warning: variable 'tun' set but not used
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/media/common/tuners/tuner-simple.c |    4 +---
>>   1 files changed, 1 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/common/tuners/tuner-simple.c b/drivers/media/common/tuners/tuner-simple.c
>> index 8abbcc5..4465b99 100644
>> --- a/drivers/media/common/tuners/tuner-simple.c
>> +++ b/drivers/media/common/tuners/tuner-simple.c
>> @@ -545,14 +545,12 @@ static int simple_set_tv_freq(struct dvb_frontend *fe,
>>   	struct tuner_simple_priv *priv = fe->tuner_priv;
>>   	u8 config, cb;
>>   	u16 div;
>> -	struct tunertype *tun;
>>   	u8 buffer[4];
>>   	int rc, IFPCoff, i;
>>   	enum param_type desired_type;
>>   	struct tuner_params *t_params;
>>
>> -	tun = priv->tun;
>> -
>> +	
> Why are you adding an extra blank line here? Except for that, the patch
> looks sane.
>

I think I was doing something wrong when creating these patches. i.g.
I just hightlight the code then move the cursor highlight all the way to 
the right before pressing "x". normally would be o.k. but for some 
reason seems to be doing this. found if I highlight left to ; (or the 
end of the code I want to delete) then git commit creates the patch 
properly.

>>   	/* IFPCoff = Video Intermediate Frequency - Vif:
>>   		940  =16*58.75  NTSC/J (Japan)
>>   		732  =16*45.75  M/N STD
>
>

I'll resend this.

Thanks for having a look.

Justin P. Mattock
