Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab2KVTj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:39:29 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42759 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152Ab2KVTjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:39:07 -0500
MIME-Version: 1.0
In-Reply-To: <50AD291A.10600@zytor.com>
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
	<1353482170-10160-12-git-send-email-yinghai@kernel.org>
	<50AD0CA1.8000904@zytor.com>
	<CAE9FiQUSjRT-r5ZE3WHVaKkUOhwFWkm9CTCv1Aa63DOsfMQMiQ@mail.gmail.com>
	<50AD291A.10600@zytor.com>
Date: Wed, 21 Nov 2012 21:56:36 -0800
X-Google-Sender-Auth: O7FZhkZIrb1l7x_zbKxe_uJuy_o
Message-ID: <CAE9FiQVed0tXhbtmc_Gug0gFZ=s=j=N4B5Vr2_ZTmSj6L-65dw@mail.gmail.com>
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

On Wed, Nov 21, 2012 at 11:18 AM, H. Peter Anvin <hpa@zytor.com> wrote:

> Then whatever loads vmlinux.elf is responsible for initializing those
> fields to zero anyway.  It is still an atrocious abuse.  What we
> probably need to do is to include the initialized header in a section in
> vmlinux.elf containing the default struct boot_params.  This is the kind
> of things that happen when people do things without thinking through all
> the consequences.

ok, will remove the version checking in kernel.

also do you still think need to move ext_ramdisk... ext_cmd_line_ptr
from setup_header to boot_param ?
