Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab2BWWMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:12:37 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56870 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab2BWWMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:12:35 -0500
Date: Thu, 23 Feb 2012 17:12:01 -0500 (EST)
Message-Id: <20120223.171201.453882925963706554.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, dkukawka@suse.de,
        bridge@lists.linux-foundation.org, leedom@chelsio.com,
        cmetcalf@tilera.com, dm@chelsio.com, divy@chelsio.com,
        gregkh@linuxfoundation.org, jdmason@kudzu.us, kristoffer@gaisler.com,
        buytenh@wantstofly.org, linux-driver@qlogic.com,
        linux-usb@vger.kernel.org, mark.einon@gmail.com, mcarlson@broadcom.com,
        mchan@broadcom.com, olof@lixom.net, linux-net-drivers@solarflare.com,
        shemminger@vyatta.com
Subject: Re: [PATCH 0/4] Part 1: unify return value of .ndo_set_mac_address
 if address is invalid
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329826072-14689-1-git-send-email-danny.kukawka@bisect.de>
References: <1329826072-14689-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 23 Feb 2012 14:12:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Tue, 21 Feb 2012 13:07:48 +0100

> Here a series of patches to unifiy the return value of 
> .ndo_set_mac_address if the given address isn't valid. 
> Return -EADDRNOTAVAIL as eth_mac_addr() and other 
> .ndo_set_mac_address functions already do if is_valid_ether_addr() 
> fails.
> 
> Other patches will follow if this set gets accepted.

All applied to net-next, thanks.
