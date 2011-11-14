Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab1KNToP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 14:44:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56020 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab1KNToN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 14:44:13 -0500
Message-ID: <4EC16F8E.7060601@gmail.com>
Date: Mon, 14 Nov 2011 20:44:14 +0100
From: Natanji <natanji@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: maciej.rutecki@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Regression in thinkpad-acpi events
References: <4EBAC3B5.5060405@gmail.com> <201111142031.06663.maciej.rutecki@gmail.com>
In-Reply-To: <201111142031.06663.maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 3.0 it was still fine, that much is for sure. The problem came 
with the upgrade to 3.1. I've never even compiled my own kernel so I 
cannot bisect. Sorry...

Regards,
Natanji

On Mon 14 Nov 2011 08:31:06 PM CET, Maciej Rutecki wrote:
> On środa, 9 listopada 2011 o 19:17:25 Natanji wrote:
>> Hello everyone,
>> first time posting on this last, and I'm not subscribed, so please CC
>> any replies to me. ;)
>>
>> I'm running Kernel version 3.1-4 using Arch Linux (32 Bit) on a Thinkpad
>> X60 Tablet. Since upgrading from a pre-3.1 kernel to a post-3.1 kernel,
>> the Thinkpad-specific ACPI events (from thinkpad-acpi) are completely gone.
>>
>> This can be observed by using the acpi_listen command. For instance, no
>> ACPI events happen when swiveling the display, and the sleep button returns
>> 	button/sleep SBTN 00000080 00000000
>> instead of the previous
>> 	ibm/hotkey HKEY 00000080 00001004
>>
>> The bug was reported in the Arch Linux bugtracker [1] and it was
>> suggested to report this upstream, so this is what I did now. Sadly I
>> have no idea how I could find out if this is indeed a kernel bug or not;
>> I have never compiled my own kernel so what I can give you is probably
>> limited. But I suppose quite a few members of this list use a Thinkpad.
>> If there is anything else I can help out with, just tell me.
>>
>> [1] https://bugs.archlinux.org/index.php?do=details&task_id=26658
>
> Can you check that 3.1 works or not? Or try bisection that it is regression 
> after 3.0 or 3.1 kernel.
>
> Regards
