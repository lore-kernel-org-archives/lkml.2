Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab2LQHqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 02:46:47 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35979 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab2LQHqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 02:46:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH 0/6] ACPI: Simplify namespace scanning for devices
Date: Mon, 17 Dec 2012 08:51:56 +0100
Message-ID: <1936282.K0prgLSgsx@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CAE9FiQXKCK=X8cay9r5YptnSiZZB=d9eC-Aa_m7QNDvVgC+0tw@mail.gmail.com>
References: <4532917.9APhB4xTvi@vostro.rjw.lan> <1904613.1YuyTUQtm1@vostro.rjw.lan> <CAE9FiQXKCK=X8cay9r5YptnSiZZB=d9eC-Aa_m7QNDvVgC+0tw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 16, 2012 11:00:04 PM Yinghai Lu wrote:
> On Sun, Dec 16, 2012 at 2:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday, December 16, 2012 09:36:49 AM Yinghai Lu wrote:
> > There you go:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git acpi-scan-temp
> >
> >> I'd like to rebase for-pci-root-bus-hotplug patches, so what should be base?
> >
> rebase all pci patches (without four patches about drivers_autoprobe
> and remove acpi_pci_root_start)
> on top your branch.
> 
> root bus hotplug seems work well without problem.
> 
> Thanks a lot.

Great, thanks for testing. :-)

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
