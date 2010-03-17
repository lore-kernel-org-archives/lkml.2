Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab0CQCWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:22:04 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:42250 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab0CQCWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:22:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=twMmIthTagMVotI9qVROBxW9RcPWAAIcsSEapwHI98ZojT+tQuyoZRscdL5EDYNDeW
         YKZdEO6NfuVYjCV/jTMc+Z4Rl+YQcdipzjGvoizlnwDBubTFYzUQf7ewf1buCR+P+V6I
         4pv2/H9BkowM4DlqCnriuhF944LPCOBVkpKOw=
Message-ID: <4BA03CC5.6000104@gmail.com>
Date: Wed, 17 Mar 2010 05:21:57 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: ACPI spam
References: <a36005b51003160819p21871af4t48a08a502afb67b5@mail.gmail.com> <201003162248.53820.rjw@sisk.pl>
In-Reply-To: <201003162248.53820.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulrich,

Please check if EC is disabled in BIOS. If it does, enable it.
It could be masked by enable ACPI 2.0 or something like that.

Regards,
Alex

Rafael J. Wysocki пишет:
> [CCing linux-acpi]
>
> On Tuesday 16 March 2010, Ulrich Drepper wrote:
>   
>> On one machine I've used using a recent kernel I see tons of messages like
>>
>> Mar 16 10:54:52 intel-d3cf1-01 kernel: ACPI Exception: AE_NOT_EXIST,
>> while evaluating GPE method [_L01] (20090903/evgpe-568)
>> Mar 16 10:54:53 intel-d3cf1-01 kernel: ACPI Error: No handler for
>> Region [ECF2] (ffff88013b69c978) [EmbeddedControl]
>> (20090903/evregion-319)
>> Mar 16 10:54:53 intel-d3cf1-01 kernel: ACPI Error: Region
>> EmbeddedControl(3) has no handler (20090903/exfldio-295)
>>
>> This is reported hundreds of times.
>>
>> Shouldn't these messages be rate-limited?  Aside from the reason being fixed.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
>>     
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

