Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965635Ab2FASXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:23:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43034 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933595Ab2FASXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:23:19 -0400
Date: Fri, 01 Jun 2012 14:23:17 -0400 (EDT)
Message-Id: <20120601.142317.1843610571282799477.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH 2/2] 8139cp/8139too: terminate the eeprom access with
 the right opmode
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120601041948.4311.42372.stgit@dhcp-8-146.nay.redhat.com>
References: <20120601041939.4311.55827.stgit@dhcp-8-146.nay.redhat.com>
	<20120601041948.4311.42372.stgit@dhcp-8-146.nay.redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri, 01 Jun 2012 12:19:48 +0800

> Currently, we terminate the eeprom access through clearing the CS by:
> 
> RTL_W8 (Cfg9346, ~EE_CS); or writeb (~EE_CS, ee_addr);
> 
> This would left the eeprom into "Config. Register Write Enable:"
> state which is not expcted as the highest two bits were set to
> 0x11 ( expected is the "Normal" mode (0x00)). Solving this by write
> 0x0 instead of ~EE_CS when terminating the eeprom access.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied.
