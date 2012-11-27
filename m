Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab2K0TdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 14:33:21 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34507 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab2K0TdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 14:33:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wen Congyang <wency@cn.fujitsu.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-acpi@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-ia64@vger.kernel.org,
        cmetcalf@tilera.com, sparclinux@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Jiang Liu <liuj97@gmail.com>,
        Len Brown <len.brown@intel.com>, benh@kernel.crashing.org,
        paulus@samba.org, Christoph Lameter <cl@linux.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jianguo Wu <wujianguo@huawei.com>
Subject: Re: [Patch v4 00/12] memory-hotplug: hot-remove physical memory
Date: Tue, 27 Nov 2012 20:38 +0100
Message-ID: <10123014.y84J4456RW@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121127112741.b616c2f6.akpm@linux-foundation.org>
References: <1354010422-19648-1-git-send-email-wency@cn.fujitsu.com> <20121127112741.b616c2f6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 27, 2012 11:27:41 AM Andrew Morton wrote:
> On Tue, 27 Nov 2012 18:00:10 +0800
> Wen Congyang <wency@cn.fujitsu.com> wrote:
> 
> > The patch-set was divided from following thread's patch-set.
> >     https://lkml.org/lkml/2012/9/5/201
> > 
> > The last version of this patchset:
> >     https://lkml.org/lkml/2012/11/1/93
> 
> As we're now at -rc7 I'd prefer to take a look at all of this after the
> 3.7 release - please resend everything shortly after 3.8-rc1.
> 
> > If you want to know the reason, please read following thread.
> > 
> > https://lkml.org/lkml/2012/10/2/83
> 
> Please include the rationale within each version of the patchset rather
> than by linking to an old email.  Because
> 
> a) this way, more people are likely to read it
> 
> b) it permits the text to be maimtained as the code evolves
> 
> c) it permits the text to be included in the mainlnie commit, where
>    people can find it.
> 
> > The patch-set has only the function of kernel core side for physical
> > memory hot remove. So if you use the patch, please apply following
> > patches.
> > 
> > - bug fix for memory hot remove
> >   https://lkml.org/lkml/2012/10/31/269
> >   
> > - acpi framework
> >   https://lkml.org/lkml/2012/10/26/175
> 
> What's happening with the acpi framework?  has it received any feedback
> from the ACPI developers?

This particular series is in my tree waiting for the v3.8 merge window.

There's a new one sent yesterday and this one is pending a review.  I'm
not sure if the $subject patchset depends on it, though.

It looks like there are too many hotplug patchsets flying left and right and
it's getting hard to keep track of them all.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
