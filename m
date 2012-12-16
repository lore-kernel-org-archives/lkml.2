Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab2LPNxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 08:53:03 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35426 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab2LPNwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 08:52:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH 0/6] ACPI: Simplify namespace scanning for devices
Date: Sun, 16 Dec 2012 14:47:42 +0100
Message-ID: <4532917.9APhB4xTvi@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This series is on top of the one I sent on Thursday:

https://lkml.org/lkml/2012/12/13/632

It goes one step farther and makes some simplifications that become possible
after applying that patchset.

[1/6] Fold acpi_pci_root_start() into acpi_pci_root_add()
[2/6] Remove acpi_start_single_object() and acpi_bus_start()
[3/6] Remove the arguments of acpi_bus_add() that are not used
[4/6] Drop the second argument of acpi_bus_scan()
[5/6] Replace ACPI device add_type field with a match_driver flag
[6/6] Make acpi_bus_scan() and acpi_bus_add() take only one argument

It survives booting on Toshiba Portege R500 without any visible issues.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
