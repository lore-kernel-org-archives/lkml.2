Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab0IHN1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:27:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56545 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab0IHN1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:27:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=aUx0r09dHA5BtRuFAjX4RN20S0U2XzTv0LZZYk+LObDWEGGiBi67Gkcx2R/0NLhs05
         KdX4fLkTmY8SnMIYQYQNokQRhQjb6FTJH9PAJnpKeRTnyu2qkmFqxSg8+i82wpfOH69L
         jlxGlcyCdtRqlHH+w0fD5DnwbiwF4LBu/i1aI=
Message-ID: <4C878F24.9010004@gmail.com>
Date: Wed, 08 Sep 2010 15:27:00 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-acpi@vger.kernel.org,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fan runs full speed after S3 sometimes (regression)
References: <4C613619.30309@gmail.com> <4C619CF0.30609@gmail.com> <20100820063107.GB1607@ucw.cz> <4C6E233A.5000209@gmail.com> <20100821170551.GA27159@elf.ucw.cz>
In-Reply-To: <20100821170551.GA27159@elf.ucw.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 08/21/2010 07:05 PM, Pavel Machek wrote:
>>>>> I don't know how to debug that. Bisection is out of question -- it
>>>>> happens once in 10 or 20 cases. There are no fan entries in /sys.
>>>
>>> Well, doing 20 suspends in a row from a script should not be too bad.
>>
>> 20 is just a guess. I haven't seen it for pretty few days until the day
>> before yesterday. And it looks like CPU1 is brought up a half way. When
>> the fan was at full speed I tried:
>> echo 0 > /sys/devices/system/cpu/cpu1/online
>> and whole system freezed. Otherwise this commands succeeds.
> 
> Ok, so this looks like the kernel problem, on the other hand. Two
> different problems?

Actually, I haven't seen it after an upgrade to the next -mm kernel.
Consider it as closed as WORKSFORME for now.

thanks anyway,
-- 
js
