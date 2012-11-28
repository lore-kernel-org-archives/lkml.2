Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab2K1U6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:58:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:31247 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab2K1U6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:58:30 -0500
Date: Wed, 28 Nov 2012 15:57:33 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/46] x86, mm: map ram from top-down with BRK and
 memblock.
Message-ID: <20121128205733.GA13915@phenom.dumpdata.com>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
 <20121127211755.GC10391@phenom.dumpdata.com>
 <20121128193523.GA18843@phenom.dumpdata.com>
 <CAE9FiQW4AiB_PdZ4UkZ9iKe0Tv-+OWzn=pJCaOvU6W1m-gPhaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQW4AiB_PdZ4UkZ9iKe0Tv-+OWzn=pJCaOvU6W1m-gPhaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 11:47:51AM -0800, Yinghai Lu wrote:
> On Wed, Nov 28, 2012 at 11:35 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> >
> > Have done so. I really like how the top-down mechanism works. It is pretty neat!
> >
> > Yinghai, I had mostly just comments about the patch descriptions -  I would
> > appreciate it you could modify the patches to address the little nitpicks I
> > spotted. And while doing that you can stick
> > 'Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>' on all patches.
> >
> > For the "x86, mm, Xen: Remove mapping_pagetable_reserve()"
> > you can also put 'Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>'
> 
> Thanks a lot for reviewing. Will update those changelog, and add
> acked-by and reviewed by...
> 
> BTW, can you please check my for-x86-boot branch that will allow
> bzImage to be loaded above 4G on 64bit platform by 64 bit bootloader.

Is there a specific boot loader I should try it out with? I am using
pxeboot and multiboot right now.

> Hope it does not break Xen dom0 and domU.

Any specific guest configs? 4G 8G 12G 30G?

> 
> Yinghai
