Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab1BNUi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 15:38:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42868
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893Ab1BNUi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 15:38:56 -0500
Date: Mon, 14 Feb 2011 12:39:32 -0800 (PST)
Message-Id: <20110214.123932.39170183.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org, sakari.ailus@iki.fi
Subject: Re: [PATCH -next] PCI: fix tlan build when CONFIG_PCI is not
 enabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110214122750.e1e03bc8.randy.dunlap@oracle.com>
References: <20110214181137.ee8d4c08.sfr@canb.auug.org.au>
	<20110214122750.e1e03bc8.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 14 Feb 2011 12:27:50 -0800

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When CONFIG_PCI is not enabled, tlan.c has a build error:
> drivers/net/tlan.c:503: error: implicit declaration of function 'pci_wake_from_d3'
> 
> so add an inline function stub for this function to pci.h when
> PCI is not enabled, similar to other stubbed PCI functions.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: David S. Miller <davem@davemloft.net>
