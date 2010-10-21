Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab0JUJyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 05:54:37 -0400
Received: from fep18.mx.upcmail.net ([62.179.121.38]:57770 "EHLO
	fep18.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab0JUJyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 05:54:36 -0400
X-SourceIP: 80.56.199.130
Subject: Re: mmotm 2010-10-20-15-01 uploaded
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20101021003008.064302ad.akpm@linux-foundation.org>
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>
	 <4CBFAB7B.7080306@cn.fujitsu.com> <4CBFB06B.3020305@cn.fujitsu.com>
	 <20101020204649.46361931.akpm@linux-foundation.org>
	 <1287645446.3488.56.camel@twins>
	 <20101021003008.064302ad.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 11:54:29 +0200
Message-ID: <1287654869.3488.96.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=BBXmjR/jrMMj1wHBsuD7Cdv69cLzNztNz9uR8CXiauo= c=1 sm=0 a=OHuDnJXnxFEA:10 a=IkcTkHD0fZMA:10 a=c10UH89C9_YC6z9DKj4A:9 a=4H_q0Dr7Z868IsQQr8XXN8lkd5cA:4 a=QEXdDO2ut3YA:10 a=QpK51Lb_erwivKpC:21 a=ZfUkq4Vc7Dni5be4:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 00:30 -0700, Andrew Morton wrote:
> btw, it's a bit sad to use KM_TYPE_NR*NR_CPUS pages of virtual address
> space for kmap_atomic().  I'd expect that distros set NR_CPUS quite
> large (Fedora has 256).  That's 20MB of virtual address space consumed,
> I think.
> 
> And we consume it on non-highmem kernels, too... 

I guess its something to look at, luckily i386 kernels tend to have
small NR_CPUS and x86_64 kernels have gobs of vaddr space so its not
really a problem, but yeah would be nice to fix.



