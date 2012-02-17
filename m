Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab2BQVDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:03:04 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54758 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab2BQVDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:03:02 -0500
Date: Fri, 17 Feb 2012 16:02:54 -0500 (EST)
Message-Id: <20120217.160254.571979413222649775.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: jcliburn@gmail.com, dkukawka@suse.de, chris.snook@gmail.com,
        jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 09/10] atheros eth: set addr_assign_type if
 random_ether_addr() used
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329493411-25750-10-git-send-email-danny.kukawka@bisect.de>
References: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de>
	<1329493411-25750-10-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 17 Feb 2012 13:02:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Fri, 17 Feb 2012 16:43:30 +0100

> Set addr_assign_type correctly to NET_ADDR_RANDOM in case
> a random MAC address was generated and assigned to the netdevice.
> 
> Fix error handling in atl1c_probe(). If atl1c_read_mac_addr()
> couldn't get the hw mac address, and a random mac address get
> set return the error code. Don't go to err_eeprom in
> atl1c_probe(), use the generated MAC address in this case.
> 
> Reset the state to NET_ADDR_PERM as soon as the MAC get
> changed via .ndo_set_mac_address.
> 
> v2: use bitops
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied.
