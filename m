Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341Ab2AEVAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 16:00:46 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61715 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab2AEVAp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 16:00:45 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <20120105181723.GA24242@srcf.ucam.org>
References: <1325610682-24811-1-git-send-email-olof@lixom.net>
	<1325610682-24811-2-git-send-email-olof@lixom.net>
	<20120105181723.GA24242@srcf.ucam.org>
Date: Thu, 5 Jan 2012 13:00:45 -0800
Message-ID: <CAOesGMiSaCvyT_fJyRgm=43NduhY9uYRrfLdVP=kPtGdVDHk8A@mail.gmail.com>
Subject: Re: [PATCH 1/5] x86: efi: refactor efi_init() a bit
From: Olof Johansson <olof@lixom.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 10:17 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Jan 03, 2012 at 09:11:18AM -0800, Olof Johansson wrote:
>
>>       if (memmap.desc_size != sizeof(efi_memory_desc_t))
>> -             printk(KERN_WARNING
>> -               "Kernel-defined memdesc doesn't match the one from EFI!\n");
>> +             printk(KERN_WARNING "Kernel-defined memdesc doesn't match the "
>> +                    "one from EFI!\n");
>
> Just kill this - it's valid per-spec, there's no reason for us to
> complain.
>
> Looks fine otherwise.

Sounds good, I removed it in v4.


-Olof
