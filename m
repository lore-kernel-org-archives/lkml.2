Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2JVTOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:14:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47337 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2JVTOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:14:15 -0400
MIME-Version: 1.0
In-Reply-To: <20121022151149.GD22780@phenom.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
	<1350593430-24470-13-git-send-email-yinghai@kernel.org>
	<20121022151149.GD22780@phenom.dumpdata.com>
Date: Mon, 22 Oct 2012 12:14:13 -0700
X-Google-Sender-Auth: 8XYC5h6iXRoAq_F8rLFpcZP1K_k
Message-ID: <CAE9FiQXQDsz2x_X0Cx=ZPVSyo1J1jad586kLoKgdo=tUxNtjHA@mail.gmail.com>
Subject: Re: [PATCH 09/19] x86, mm: Merge alloc_low_page between 64bit and 32bit
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 8:11 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
> On Thu, Oct 18, 2012 at 01:50:20PM -0700, Yinghai Lu wrote:
>> They are almost same except 64 bit need to handle after_bootmem.
>                                                                  ^^ -
> case.
>
>>
>> Add mm_internal.h to hide that alloc_low_page out of arch/x86/mm/init*.c
>
> Huh?
>
> I think what you are saying is that you want to expose alloc_low_page
> decleration in a header since the function resides in mm/init_[32|64].c ?


---
They are almost same except 64 bit need to handle after_bootmem case.

Add mm_internal.h to make that alloc_low_page() only to be accessible
from arch/x86/mm/init*.c
---
