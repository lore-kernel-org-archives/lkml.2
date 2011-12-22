Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab1LVWCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 17:02:35 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:38488 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1LVWCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 17:02:32 -0500
Date: Thu, 22 Dec 2011 17:02:27 -0500 (EST)
Message-Id: <20111222.170227.1906514601375643135.davem@davemloft.net>
To: bhelgaas@google.com
Cc: James.Bottomley@hansenpartnership.com, linux-pci@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org
Subject: Re: [PATCH v2 00/29] Create PCI root buses with correct resources
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111222.145629.505018474228371646.davem@davemloft.net>
References: <20111222.135911.584309149966835644.davem@davemloft.net>
	<20111222.141537.1513319029738355747.davem@davemloft.net>
	<20111222.145629.505018474228371646.davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 22 Dec 2011 14:02:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 22 Dec 2011 14:56:29 -0500 (EST)

> In my case arch_setup_msi_irqs() is failing simply because MSI has
> not been enabled on these PCI host bridges.  It should, and I'm
> trying to figure out if this is some strange interaction with the
> new resource code.

It wasn't a problem with the resource changes, it's a sparc64 problem
that only triggers on more recent systems.

The MSI SYSFS error handling is, of course, still needing to be fixed.
