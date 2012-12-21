Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab2LUWST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 17:18:19 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40282 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab2LUWSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 17:18:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH 0/16] ACPI: Rework ACPI namespace scanning for devices
Date: Fri, 21 Dec 2012 23:23:31 +0100
Message-ID: <3550843.LLuPaOBdqu@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CAE9FiQUO16M+_HG7=adYN1B8GpMgL3_rEzCtp5MjGcw2enMw_Q@mail.gmail.com>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <12351296.YKgNhoGAuR@vostro.rjw.lan> <CAE9FiQUO16M+_HG7=adYN1B8GpMgL3_rEzCtp5MjGcw2enMw_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 20, 2012 07:59:15 PM Yinghai Lu wrote:
> On Thu, Dec 20, 2012 at 4:09 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday, December 19, 2012 06:06:57 PM Yinghai Lu wrote:
> >> On Wed, Dec 19, 2012 at 5:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>
> >> great!, the .bind and .unbind go away.
> >>
> >> >
> >> > The patches are on top of my master branch and I'm going to rebase them when
> >> > v3.8-rc1 is out.
> >>
> >> >
> >> > There is a git tree you can pull them from at:
> >> >
> >> > http://git.kernel.org/?p=linux/kernel/git/rafael/linux-pm.git;a=summary acpi-scan-temp-new
> >> >
> >> > It's v3.7 with my master branch merged and the new patches on top.
> >>
> >>
> >> can you make it base to today's Linus tree ?
> >
> > Sure.  Rebased and pushed out:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git acpi-scan-next
> >
> 
> Thanks.
> 
> I rebased pci-root-bus-hotplug patchset on top it, and it works well.

Great, thanks for testing!

> So
> Acked-by: Yinghai Lu <yinghai@kernel.org>
> for the four new ones in your acpi_scan_next branch.

Thanks!

I'll rebase the whole series on top of v3.8-rc1 when it's out.

> i put the updated patches in
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-pci-root-bus-3.9

OK, thanks.

I'll have a look at that series next week.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
