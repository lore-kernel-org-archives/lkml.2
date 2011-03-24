Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab1CXURT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:17:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32963 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093Ab1CXURR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:17:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MHRi7W6KQ8iPvidvoHVWwHA5CNGBqg9ocWgBqzo11EQwpN+WYqQXocJzZjIRuk6fO8
         2JeX6f2dsrOvXRWaBaS+oUdVfMYQpEKMZCcS3U2HVRqrvk8UWV22rVTxbcAVtVsQFHlM
         NEGoDzy28+aAgoSsYzm5SjZi4ciNLpzDzwRx4=
Message-ID: <4D8BA6C4.2090008@gmail.com>
Date: Thu, 24 Mar 2011 13:17:08 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110316 Thunderbird/3.1.9
MIME-Version: 1.0
To: Nick Bowler <nbowler@elliptictech.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 01/21]arch:arm:mach Remove extra comma.
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com> <20110324201602.GA28979@elliptictech.com>
In-Reply-To: <20110324201602.GA28979@elliptictech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 01:16 PM, Nick Bowler wrote:
> On 2011-03-24 12:26 -0700, Justin P. Mattock wrote:
>> The patch below removes an extra comma from various parts
>> of the kernel. Please have a look when you have time, and let
>> me know if its legit or not.
>
> You say here that you are removing commas...

I know!! just got an email from randy dunlop on that..(pretty bad) I am 
resending..

>
>> diff --git a/arch/arm/mach-at91/at91cap9_devices.c b/arch/arm/mach-at91/at91cap9_devices.c
> [...]
>> -	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));;
>> +	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));
>
> ...yet you are actually removing semicolons.
>

