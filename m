Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab1JNEoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:44:06 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34056 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab1JNEoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:44:04 -0400
Date: Fri, 14 Oct 2011 00:43:41 -0400 (EDT)
Message-Id: <20111014.004341.375430413116543198.davem@davemloft.net>
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 15/29] sparc32, leon/PCI: convert to
 pci_scan_root_bus() for correct root bus resources
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111014042823.23504.88314.stgit@bhelgaas.mtv.corp.google.com>
References: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
	<20111014042823.23504.88314.stgit@bhelgaas.mtv.corp.google.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 13 Oct 2011 21:44:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 13 Oct 2011 22:28:23 -0600

> Convert from pci_scan_bus_parented() to pci_scan_root_bus() and remove root
> bus resource fixups.  This fixes the problem of "early" and "header" quirks
> seeing incorrect root bus resources.
> 
> pci_scan_root_bus() also includes the pci_bus_add_devices() so we don't
> need to do that separately.
> 
> CC: David S. Miller <davem@davemloft.net>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Acked-by: David S. Miller <davem@davemloft.net>
