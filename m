Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0GKCJm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 22:09:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33936
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751910Ab0GKCJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 22:09:41 -0400
Date: Sat, 10 Jul 2010 19:09:54 -0700 (PDT)
Message-Id: <20100710.190954.245403400.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for July 6 (NET_DSA + PHYLIB kconfig)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100706103417.8923b697.randy.dunlap@oracle.com>
References: <20100706190519.93d8b785.sfr@canb.auug.org.au>
	<20100706103417.8923b697.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 6 Jul 2010 10:34:17 -0700

> NET_DSA selects PHYLIB.  PHYLIB depends on NET_ETHERNET, which is not enabled
> in this randconfig.  net/dsa code does need PHYLIB code, so PHYLIB symbol should
> either drop "depends on NET_ETHERNET" or it should be changed to
> 	depends on NET_ETHERNET || NET_DSA
> 
> Preference?

The situations seems to suggest NET_DSA depends upon NET_ETHERNET, so
adding NET_ETHERNET to NET_DSA's dependencies probably works better.
