Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab2LQHAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 02:00:07 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53031 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2LQHAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 02:00:05 -0500
MIME-Version: 1.0
In-Reply-To: <1904613.1YuyTUQtm1@vostro.rjw.lan>
References: <4532917.9APhB4xTvi@vostro.rjw.lan>
	<CAE9FiQUgEv0Ub8jAuuHzzOGqinbm0Nm5iiBs1ugRg5OT09h4+A@mail.gmail.com>
	<1904613.1YuyTUQtm1@vostro.rjw.lan>
Date: Sun, 16 Dec 2012 23:00:04 -0800
X-Google-Sender-Auth: RFSg25Pv9tqNobzYNm1h1zbJbmg
Message-ID: <CAE9FiQXKCK=X8cay9r5YptnSiZZB=d9eC-Aa_m7QNDvVgC+0tw@mail.gmail.com>
Subject: Re: [PATCH 0/6] ACPI: Simplify namespace scanning for devices
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 2:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, December 16, 2012 09:36:49 AM Yinghai Lu wrote:
> There you go:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git acpi-scan-temp
>
>> I'd like to rebase for-pci-root-bus-hotplug patches, so what should be base?
>
rebase all pci patches (without four patches about drivers_autoprobe
and remove acpi_pci_root_start)
on top your branch.

root bus hotplug seems work well without problem.

Thanks a lot.

Yinghai
