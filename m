Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1JKDdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 23:33:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55726 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab1JKDdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 23:33:53 -0400
Date: Mon, 10 Oct 2011 23:33:50 -0400 (EDT)
Message-Id: <20111010.233350.1059790226878565265.davem@davemloft.net>
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] sparc/pci: supply root bus resources to
 pci_create_bus()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111011031929.5149.58149.stgit@bhelgaas.mtv.corp.google.com>
References: <20111011030726.5149.23793.stgit@bhelgaas.mtv.corp.google.com>
	<20111011031929.5149.58149.stgit@bhelgaas.mtv.corp.google.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 10 Oct 2011 20:33:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 10 Oct 2011 21:19:29 -0600

> Pass root bus resources to pci_create_bus() so the bus resources are
> correct from the beginning.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Acked-by: David S. Miller <davem@davemloft.net>
