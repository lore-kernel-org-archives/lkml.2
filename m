Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab0FBOFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 10:05:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44639
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757632Ab0FBOFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 10:05:21 -0400
Date: Wed, 02 Jun 2010 07:05:31 -0700 (PDT)
Message-Id: <20100602.070531.73368509.davem@davemloft.net>
To: fengguang.wu@intel.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org
Subject: Re: [PATCH] ipconfig: send host-name in DHCP requests
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100531031953.GA10590@localhost>
References: <20100531031953.GA10590@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Fengguang <fengguang.wu@intel.com>
Date: Mon, 31 May 2010 11:19:53 +0800

> Normally dhclient can be configured to send the "host-name" option
> in DHCP requests to update the client's DNS record. However for an
> NFSROOT system, dhclient shall never be called (which may change the
> IP addr and therefore lose your root NFS mount connection).
> 
> So enable updating the DNS record with kernel parameter
> 
> 	ip=::::$HOST_NAME::dhcp
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Applied, thanks.
