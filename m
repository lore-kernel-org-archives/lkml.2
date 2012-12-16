Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab2LPW0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 17:26:12 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35706 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab2LPW0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 17:26:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH 0/6] ACPI: Simplify namespace scanning for devices
Date: Sun, 16 Dec 2012 23:31:19 +0100
Message-ID: <1904613.1YuyTUQtm1@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CAE9FiQUgEv0Ub8jAuuHzzOGqinbm0Nm5iiBs1ugRg5OT09h4+A@mail.gmail.com>
References: <4532917.9APhB4xTvi@vostro.rjw.lan> <CAE9FiQUgEv0Ub8jAuuHzzOGqinbm0Nm5iiBs1ugRg5OT09h4+A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 16, 2012 09:36:49 AM Yinghai Lu wrote:
> On Sun, Dec 16, 2012 at 5:47 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Hi All,
> >
> > This series is on top of the one I sent on Thursday:
> >
> > https://lkml.org/lkml/2012/12/13/632
> >
> > It goes one step farther and makes some simplifications that become possible
> > after applying that patchset.
> >
> > [1/6] Fold acpi_pci_root_start() into acpi_pci_root_add()
> > [2/6] Remove acpi_start_single_object() and acpi_bus_start()
> > [3/6] Remove the arguments of acpi_bus_add() that are not used
> > [4/6] Drop the second argument of acpi_bus_scan()
> > [5/6] Replace ACPI device add_type field with a match_driver flag
> > [6/6] Make acpi_bus_scan() and acpi_bus_add() take only one argument
> >
> > It survives booting on Toshiba Portege R500 without any visible issues.
> 
> Do you have git branch that i could test?

There you go:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git acpi-scan-temp

> I'd like to rebase for-pci-root-bus-hotplug patches, so what should be base?

I'll need to talk about that with Bjorn.  Hopefully he'll be reachable tomorrow.

> It would be hard for me to base on your acpi tree and Bjorn's pci tree.

We'll work out something.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
