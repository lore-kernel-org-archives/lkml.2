Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357Ab0JYXr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:47:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52732
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757170Ab0JYXrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:47:24 -0400
Date: Mon, 25 Oct 2010 16:47:47 -0700 (PDT)
Message-Id: <20101025.164747.189713145.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH -next] pch_can: depends on PCI
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101025162524.570fc82a.randy.dunlap@oracle.com>
References: <20101025145834.9b68e026.sfr@canb.auug.org.au>
	<20101025162524.570fc82a.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 25 Oct 2010 16:25:24 -0700

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix pch_can build when CONFIG_PCI is not enabled.  It uses pci interfaces
> and data structures, so it should depend on PCI.
> 
> drivers/net/can/pch_can.c:1044: error: implicit declaration of function 'pci_enable_msi'
> drivers/net/can/pch_can.c:1079: error: implicit declaration of function 'pci_disable_msi'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks Randy.
