Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab2KVSwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:52:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36999 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab2KVSwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:52:03 -0500
Message-ID: <50AE7429.6030308@zytor.com>
Date: Thu, 22 Nov 2012 10:51:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v3 11/12] x86, boot: add fields to support load bzImage
 and ramdisk high
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org> <1353482170-10160-12-git-send-email-yinghai@kernel.org> <50AD0CA1.8000904@zytor.com> <CAE9FiQUSjRT-r5ZE3WHVaKkUOhwFWkm9CTCv1Aa63DOsfMQMiQ@mail.gmail.com> <50AD291A.10600@zytor.com> <CAE9FiQVed0tXhbtmc_Gug0gFZ=s=j=N4B5Vr2_ZTmSj6L-65dw@mail.gmail.com> <a1ca794a-09d4-4d36-8c8c-67100cb3696e@email.android.com> <CAE9FiQXJO8uxT9Gzjv9e8XeiLzwBX7fwTFzDVy=oPfboG4L=3Q@mail.gmail.com> <CAE9FiQWeGz2TkLBrBZcoPrNABx51XK3xk58P+Zam_LRGoJdSiw@mail.gmail.com> <a8b15bf0-4e3b-4fde-9190-26890f9abf77@email.android.com> <CAE9FiQUoj9k0Tbqp8LC8Wb21_s_x8naiWX4zkX9pJG-oFnAQ9g@mail.gmail.com> <50AE70E7.6060204@zytor.com> <CAE9FiQXKgnZyFNujKhMn94+0JQ6jtAHOihmtMOmk_gJi-4_aYQ@mail.gmail.com>
In-Reply-To: <CAE9FiQXKgnZyFNujKhMn94+0JQ6jtAHOihmtMOmk_gJi-4_aYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2012 10:50 AM, Yinghai Lu wrote:
>
> ok, I will use 0xc0 instead, and at the same time try to fix that from kexec.
>
> then user will still have chance to use old kexec tools without enable
> CONFIG_EFI_STUB in kernel.
>

If we can get the sentinel hack to work that would probably be useful, 
but we need to understand the exact pathology.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

