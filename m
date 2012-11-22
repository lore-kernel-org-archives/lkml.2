Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2KVSuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:50:14 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40020 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab2KVSuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:50:08 -0500
MIME-Version: 1.0
In-Reply-To: <50AE70E7.6060204@zytor.com>
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
	<1353482170-10160-12-git-send-email-yinghai@kernel.org>
	<50AD0CA1.8000904@zytor.com>
	<CAE9FiQUSjRT-r5ZE3WHVaKkUOhwFWkm9CTCv1Aa63DOsfMQMiQ@mail.gmail.com>
	<50AD291A.10600@zytor.com>
	<CAE9FiQVed0tXhbtmc_Gug0gFZ=s=j=N4B5Vr2_ZTmSj6L-65dw@mail.gmail.com>
	<a1ca794a-09d4-4d36-8c8c-67100cb3696e@email.android.com>
	<CAE9FiQXJO8uxT9Gzjv9e8XeiLzwBX7fwTFzDVy=oPfboG4L=3Q@mail.gmail.com>
	<CAE9FiQWeGz2TkLBrBZcoPrNABx51XK3xk58P+Zam_LRGoJdSiw@mail.gmail.com>
	<a8b15bf0-4e3b-4fde-9190-26890f9abf77@email.android.com>
	<CAE9FiQUoj9k0Tbqp8LC8Wb21_s_x8naiWX4zkX9pJG-oFnAQ9g@mail.gmail.com>
	<50AE70E7.6060204@zytor.com>
Date: Thu, 22 Nov 2012 10:50:07 -0800
X-Google-Sender-Auth: EBvHpPJzTTCLQrwH4SGXkRkFsFg
Message-ID: <CAE9FiQXKgnZyFNujKhMn94+0JQ6jtAHOihmtMOmk_gJi-4_aYQ@mail.gmail.com>
Subject: Re: [PATCH v3 11/12] x86, boot: add fields to support load bzImage
 and ramdisk high
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 10:37 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> looks we only can use [0x30,0x3c), [0x1e8, 0x1f0), but in boot_params,
>> they
>> are apm_bios_info, and alt_mem_k...
>
>
> ... which I suspect get set by said kexec botch.
>
>
>> so looks we still have to use setup_header instead.
>
>
> We need to dig into this and either say "this is unsupportable" or put in
> some kind of hack.

ok, I will use 0xc0 instead, and at the same time try to fix that from kexec.

then user will still have chance to use old kexec tools without enable
CONFIG_EFI_STUB in kernel.

Thanks

Yinghai
