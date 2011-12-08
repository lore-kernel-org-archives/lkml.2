Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1LHTBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 14:01:46 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62366 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab1LHTBl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 14:01:41 -0500
MIME-Version: 1.0
In-Reply-To: <20111208072412.e9cf00f9bcdbc4450fe2d2d4@canb.auug.org.au>
References: <20111207170533.3dea865573c916e79d274eca@canb.auug.org.au>
	<CAErSpo59CuEBbu4QWMkK23TyXafhMLOh1G7Z8YxojqiQmCM0Fw@mail.gmail.com>
	<20111208072412.e9cf00f9bcdbc4450fe2d2d4@canb.auug.org.au>
Date: Thu, 8 Dec 2011 11:01:40 -0800
X-Google-Sender-Auth: WC0jA2T3B_34D1GTDv-m_xj6uog
Message-ID: <CA+8MBb+n_y=BGQihjGujAq7=cUwpdOTP0-7uRoftFeXouD=QHw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (pci tree related)
From: Tony Luck <tony.luck@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia64 builds are failing to build next-20111208


arch/ia64/pci/pci.c: In function ‘add_window’:
arch/ia64/pci/pci.c:321: error: ‘struct acpi_resource’ has no member
named ‘flags’
arch/ia64/pci/pci.c:322: error: ‘struct acpi_resource’ has no member named ‘end’
arch/ia64/pci/pci.c:322: error: ‘struct acpi_resource’ has no member
named ‘start’

problem from this commit


commit ab57d8e403c084bf5bacae31d6bc14bef9b75a22
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Fri Oct 28 16:26:31 2011 -0600

    ia64/PCI: convert to pci_create_root_bus() for correct root bus resources

-Tony
