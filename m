Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab2KICHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 21:07:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab2KICHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 21:07:49 -0500
Date: Thu, 8 Nov 2012 18:07:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyberman Wu <cypher.w@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Is this a kernel bug?
Message-Id: <20121108180746.f393aca1.akpm@linux-foundation.org>
In-Reply-To: <CADCVGbR-39diiMA-C2cEn315r916HMprt6Lx4s8qN8jHC_e8FQ@mail.gmail.com>
References: <CADCVGbSC-T=W08xcf9rDynS8Uf9yq=KKTNUn33g-O_FqyQkU_A@mail.gmail.com>
	<20121107162840.GA2660@mtj.dyndns.org>
	<CADCVGbR-39diiMA-C2cEn315r916HMprt6Lx4s8qN8jHC_e8FQ@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2012 08:53:49 +0800 Cyberman Wu <cypher.w@gmail.com> wrote:

> A lot of these message on many CPU:
> 
> ...
>
> Starting stack dump of tid 906, pid 906 (kworker/16:1) on cpu 16 at
> cycle 416925426066163
>   frame 0: 0xfffffff700375f58 kthread_data+0x18/0x20 (sp 0xfffffe00f9fbf430)
>   frame 1: 0xfffffff700357fe8 wq_worker_sleeping+0x28/0xf8 (sp
> 0xfffffe00f9fbf430)
>   frame 2: 0xfffffff700021ab8 schedule+0xd00/0x1538 (sp 0xfffffe00f9fbf448)
>   frame 3: 0xfffffff70041f950 do_exit+0x510/0x658 (sp 0xfffffe00f9fbf790)
>   frame 4: 0xfffffff7000ade50 do_group_exit+0xc0/0x220 (sp 0xfffffe00f9fbf840)
>   frame 5: 0xfffffff7001137a0 jit_bundle_gen+0xf20/0x27d8 (sp
> 0xfffffe00f9fbf878)

I don't recognize jit_bundle_gen.  Has this kernel been modified?

>   frame 6: 0xfffffff70034e830 do_unaligned+0xe0/0x5b0 (sp 0xfffffe00f9fbfac8)
>   frame 7: 0xfffffff700139af8 handle_interrupt+0x270/0x278 (sp
> 0xfffffe00f9fbfc00)
>   <interrupt 17 while in kernel mode>
>   frame 8: 0xfffffff7002fc488 worker_enter_idle+0x1c8/0x2e8 (sp
> 0xfffffe00f9fbfe78)
>   frame 9: 0xfffffff7002750c8 worker_thread+0x4c8/0x898 (sp 0xfffffe00f9fbfea0)
>   frame 10: 0xfffffff7000f0530 kthread+0xe0/0xe8 (sp 0xfffffe00f9fbff80)
>   frame 11: 0xfffffff7000bab38 start_kernel_thread+0x18/0x20 (sp

