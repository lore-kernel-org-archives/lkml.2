Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab2LMJu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 04:50:29 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57009 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2LMJu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 04:50:26 -0500
MIME-Version: 1.0
Date: Thu, 13 Dec 2012 17:50:24 +0800
Message-ID: <CANmqhJAuLoi_Y2Hsz+UnddHXYd9TCW-7qxp3fybDayfh33Y3Zg@mail.gmail.com>
Subject: DMAR and DRHD errors[DMAR:[fault reason 06] PTE Read access is not
 set] Vt-d & intel_iommu
From: Jason Gao <pkill.2012@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear List:

Description of problem:
After installed Centos 6.3(RHEL6.3) on my Dell R710(lastest
bios:Version: 6.3.0,Release Date: 07/24/2012) server,and updated
lastest kernel "2.6.32-279.14.1.el6.x86_64",I want to use the Intel
82576 ET Dual Port nic's SR-IOV feature,assigning VFs to kvm guest

appended kernel boot parameter: intel_iommu=on,after boot with the
following messages:

Dec 13 16:58:15 2 kernel: DRHD: handling fault status reg 2
Dec 13 16:58:15 2 kernel: DMAR:[DMA Read] Request device [03:00.0]
fault addr ffe65000
Dec 13 16:58:15 2 kernel: DMAR:[fault reason 06] PTE Read access is not set
Dec 13 16:58:15 2 kernel: DRHD: handling fault status reg 102
Dec 13 16:58:15 2 kernel: DMAR:[DMA Read] Request device [03:00.0]
fault addr ffe8a000
Dec 13 16:58:15 2 kernel: DMAR:[fault reason 06] PTE Read access is not set
Dec 13 16:58:15 2 kernel: scsi 0:0:32:0: Enclosure         DP
BACKPLANE        1.07 PQ: 0 ANSI: 5
Dec 13 16:58:15 2 kernel: DRHD: handling fault status reg 202
Dec 13 16:58:15 2 kernel: DMAR:[DMA Read] Request device [03:00.0]
fault addr ffe89000
Dec 13 16:58:15 2 kernel: DMAR:[fault reason 06] PTE Read access is not set

full dmesg detail:
   http://pastebin.com/BzFQV0jU
lspci -vvv full detail:
   http://pastebin.com/9rP2d1br


it's a production server,and I'm not sure if this is a critical
problem,how to fix it,any help would be greatly appreciated.
