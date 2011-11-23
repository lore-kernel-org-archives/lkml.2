Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540Ab1KWApE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:45:04 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35391 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab1KWApA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:45:00 -0500
Message-ID: <4ECC4207.3010607@gmail.com>
Date: Wed, 23 Nov 2011 01:44:55 +0100
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Mike Waychison <mikew@google.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v5 10/10] x86, efi: EFI boot stub support
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>  <1318848017-12301-11-git-send-email-matt@console-pimps.org>  <4E9C8AAC.7080803@gmail.com> <1321383097.2657.9.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1321383097.2657.9.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Matt,

On 11/15/2011 07:51 PM, Matt Fleming wrote:
> On Mon, 2011-10-17 at 22:06 +0200, Maarten Lankhorst wrote:
>> Seems initrd is failing for me. Is there any limitation on the size of
>> the initrd? The default one fedora generates for my kernel is 46mb. It
>> loads the kernel, but it reboots before it gets to userspace. Loading
>> the kernel and initrd with grub2-efi works. EFI booting without initrd
>> works too.
> Sorry it took me so long to reply to this! Could you try version 6 of
> this patch?
>
> From 5f1a572e59915daaa263093f0a2f180c88fa8504 Mon Sep 17 00:00:00 2001
> From: Matt Fleming <matt.fleming@intel.com>
> Date: Wed, 20 Jul 2011 09:24:53 +0100
> Subject: [PATCH v6] x86, efi: EFI boot stub support
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
>
> v6:
>
>  - Try to allocate initrd memory just below hdr->inird_addr_max.
>
When I tested this with v3.2-rc2 it didn't boot, it hung before it initialized the kernel.
Without initrd it works fine, though.

~Maarten
