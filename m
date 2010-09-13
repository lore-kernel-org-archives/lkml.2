Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab0IMSMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:12:48 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:65357 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab0IMSMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:12:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EAovv2ruhWw/CEYF3BKaHjpCYqpz6Oz7kdj6tBFOPhcYo90VsHhfLccrpJpnJkE90h
         TJ4hhsm/6U7QZgC0Jk5h2luf3PVYMcZG+IMLc4QuN6NrR/LoIY9BJlL+fevCLohZrw79
         rXDawDcm/ctrv3qzDz5rr/52m3akUxkM5P4Co=
Message-ID: <4C8E69C7.2080508@gmail.com>
Date: Mon, 13 Sep 2010 11:13:27 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 3,5,7/8] sound/* Update broken web addresses.
References: <1284222928-4150-1-git-send-email-justinmattock@gmail.com> <1284222928-4150-7-git-send-email-justinmattock@gmail.com> <4C8E25ED.3090803@ladisch.de>
In-Reply-To: <4C8E25ED.3090803@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 06:23 AM, Clemens Ladisch wrote:
> Justin P. Mattock wrote:
>> --- a/sound/oss/ac97_codec.c
>> +++ b/sound/oss/ac97_codec.c
>>    * The Intel Audio Codec '97 specification is available at the Intel
>   >- * audio homepage: http://developer.intel.com/ial/scalableplatforms/audio/
>> + * audio homepage: http://developer.intel.com/
>
> drop this link
>
>>    * The specification itself is currently available at:
>> - * ftp://download.intel.com/ial/scalableplatforms/ac97r22.pdf
>> + * ftp://ftp.intel.com/pub/
>
> http://download.intel.com/support/motherboards/desktop/sb/ac97_r23.pdf
>
>> --- a/sound/pci/ens1370.c
>> +++ b/sound/pci/ens1370.c
>> - * using http://www.alsa-project.org/~iwai/writing-an-alsa-driver/c1540.htm
>> + * using http://www.alsa-project.org/~iwai/
>
> http://www.kernel.org/pub/linux/kernel/people/tiwai/docs/writing-an-alsa-driver/index.html
>
>> --- a/sound/pci/intel8x0.c
>> +++ b/sound/pci/intel8x0.c
>> - *	http://www.intel.com/design/chipsets/specupdt/245051.htm
>> + *	http://www.intel.com/p/en_US/business/design	
>
> http://download.intel.com/design/chipsets/specupdt/24505108.pdf
>


ahh.. you know how to navigate through the intel's site better than I 
do... I'll drop the link, and add the others...

Thanks..

Justin P. Mattock
