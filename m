Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab1IEOzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 10:55:48 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50563 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab1IEOzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 10:55:45 -0400
MIME-Version: 1.0
Date: Mon, 5 Sep 2011 22:55:45 +0800
Message-ID: <CAAJw_Zv9LaOut6+aQWki_-nCngEEfh-OVqF4rsUwb-LPfLk8Ug@mail.gmail.com>
Subject: linux-3.1-0-rc4 bus error ... MPS configured higher than maximum
 supported by the device. If a bus issue occurs, try running with pci=pcie_bus_safe.
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, Jordan_Hargrave@dell.com,
        Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got the following error after upgrading from linux-2.6.36 to
linux-3.1.0-rc4 on a Dell PowerEdge 2950 that has a PCIe fax card, and
the system LED panel shows "Bus Fatal Error".


Is is normal or should I try out "pci=pcie_bus_safe" or "pci=pci" as
suggested in the dmesg?

There was another error that also showed up on 2.6.36 but I'm ignoring
that for now ( ... disabling ASPM on pre-1.1 PCIe device.  You can
enable it with 'pcie_aspm=force')

pci 0000:07:00.0: Dev MPS 128 MPSS 256 MRRS 4096
pci 0000:07:00.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:08:00.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:08:00.0: MPS configured higher than maximum supported by the
device.  If a bus issue occurs, try running with pci=pcie_bus_safe.
pci 0000:08:00.0: Dev MPS 256 MPSS 256 MRRS 128
Uhhuh. NMI received for unknown reason 31 on CPU 0.
Do you have a strange power saving mode enabled?
Dazed and confused, but trying to continue
pci 0000:07:01.0: Dev MPS 128 MPSS 256 MRRS 4096
pci 0000:07:01.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:00:06.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:0e:00.0: Dev MPS 128 MPSS 128 MRRS 512
pci 0000:0e:00.0: MPS configured higher than maximum supported by the
device.  If a bus issue occurs, try running with pci=pci


Thanks,
Jeff.
