Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab0JQUuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 16:50:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55327
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932825Ab0JQUuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 16:50:54 -0400
Date: Sun, 17 Oct 2010 13:51:16 -0700 (PDT)
Message-Id: <20101017.135116.39183656.davem@davemloft.net>
To: joe@perches.com
Cc: masa-korg@dsn.okisemi.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] drivers/net/pch_gbe: Use
 DEFINE_PCI_DEVICE_TABLE
From: David Miller <davem@davemloft.net>
In-Reply-To: <1287086150.1117.608.camel@Joe-Laptop>
References: <1287086150.1117.608.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 14 Oct 2010 12:55:50 -0700

> Use the standard macro to put this table in __devinitconst.
> 
> Compiled, untested.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.
