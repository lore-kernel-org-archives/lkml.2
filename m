Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab1AaKaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:30:07 -0500
Received: from mailout08.t-online.de ([194.25.134.20]:43965 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab1AaKaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:30:03 -0500
Message-ID: <4D468F1F.8030704@t-online.de>
Date: Mon, 31 Jan 2011 11:29:51 +0100
From: =?UTF-8?B?UmljaGFyZCBTY2jDvHR6?= <r.schtz@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101230 Lanikai/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        colin.king@canonical.com
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus
 laptops)
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <201101311050.49722.rjw@sisk.pl> <4D468CF0.9040103@t-online.de> <201101311123.14704.rjw@sisk.pl>
In-Reply-To: <201101311123.14704.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: VbTJSkZDrhippSlPgx5abFVIblbqRhkD+DGX3Ocm8CJMC9U-QLnO8lLstO7mMs9g5v
X-TOI-MSGID: 01f0c4e0-1a44-4a3f-895e-85c1417963f7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> I'll compile a kernel with CONFIG_NO_HZ to see what happens but how do I
>>>> disable cpuidle during boot? I've checked the kernel-parameters.txt but
>>>> there's no cpuidle related boot parameter there.
>>>
>>> Booting with intel_idle.max_cstate=0 should do the trick.
>>
>> intel_idle.max_cstate=0 causes a fallback to the acpi_idle driver. So it
>> does not disable the C-states directly.
>
> What about not building the acpi_idle driver, then?

Or just use the processor.max_cstate parameter then.

-- 
Regards,
Richard Schütz
