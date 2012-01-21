Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab2AUK0u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:26:50 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55079 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab2AUK0r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:26:47 -0500
MIME-Version: 1.0
In-Reply-To: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
References: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
Date: Sat, 21 Jan 2012 02:26:46 -0800
X-Google-Sender-Auth: buRUYBIJuGjt_mlo2yiTtv9BBkA
Message-ID: <CAE9FiQUFYcaVWorPPP7PQqiBPnKv-iBkPm_qbGz4T_xLR2THiQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] PCI: pcie hotplug related patch
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 1:52 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> b40c9ef: pciehp: Disable/enable link during slot power off/on
> fe877ae: pciehp: Add Disable/enable link functions
> 292e286: pciehp: Add pcie_wait_link_not_active()
> 186b3fd: pciehp: print out link status when dlla get active.
> 2781df4: pciehp: Checking pci conf reading to new added device instead of sleep 1s
> bf1c4ac: PCI: Separate pci_bus_read_dev_vendor_id from pci_scan_device
> 601c6f1: PCI: Make sriov work with hotplug remove
>
>  drivers/pci/hotplug/pciehp_hpc.c |  133 +++++++++++++++++++++++++++++++-------
>  drivers/pci/pci.h                |    2 +
>  drivers/pci/probe.c              |   48 +++++++++-----
>  drivers/pci/remove.c             |   28 ++++++++-
>  4 files changed, 169 insertions(+), 42 deletions(-)
>
> First one is for hotplug with sriov under bridge.
> following two are for hotplug probing with pci conf reading.
> Last four are for pcie link disable when power off slots.

could be found at:

	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-pci-hp

Thanks

Yinghai
