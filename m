Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab1C3Jgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:36:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43829
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137Ab1C3Jgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:36:47 -0400
Date: Wed, 30 Mar 2011 02:36:09 -0700 (PDT)
Message-Id: <20110330.023609.91338968.davem@davemloft.net>
To: andrew.zaborowski@intel.com
Cc: netdev@vger.kernel.org, oliver@neukum.name,
        dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
        balrogg@gmail.com
Subject: Re: [PATCH v2] net/usb: Ethernet quirks for the LG-VL600 4G modem
From: David Miller <davem@davemloft.net>
In-Reply-To: <1301352993-21535-1-git-send-email-andrew.zaborowski@intel.com>
References: <1301263473-27849-1-git-send-email-andrew.zaborowski@intel.com>
	<1301352993-21535-1-git-send-email-andrew.zaborowski@intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Date: Tue, 29 Mar 2011 00:56:33 +0200

> This adds a driver for the CDC Ethernet part of this modem.  The
> device's ID is blacklisted in cdc_ether.c and is white-listed in
> this new driver because of the quirks needed to make it useful.
> The modem's firmware exposes a CDC ACM port for modem control and a
> CDC Ethernet port for network data.  The descriptors look fine but
> both ports actually are some sort of multiplexers requiring non-
> standard headers added/removed from every packet or they get
> ignored.  All information is based on a usb traffic log from a
> Windows machine.
> 
> On the Verizon 4G network I've seen speeds up to 1.1MB/s so far with
> this driver, a speed-o-meter site reports 16.2Mbps/10.5Mbps.
> Userspace scripts are required to talk to the CDC ACM port.
> 
> Signed-off-by: Andrzej Zaborowski <balrogg@gmail.com>

Applied, thanks.
