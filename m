Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab2BOUgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:36:31 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:60405 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab2BOUg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:36:29 -0500
Date: Wed, 15 Feb 2012 15:34:55 -0500 (EST)
Message-Id: <20120215.153455.1834741004962671833.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: dkukawka@suse.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, eilong@broadcom.com, steve.glendinning@smsc.com,
        cmetcalf@tilera.com, kaber@trash.net, jpirko@redhat.com,
        shemminger@vyatta.com, jesse@nicira.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v2 2/2] net: use eth_hw_addr_random() and reset
 addr_assign_type
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329324340-13461-3-git-send-email-danny.kukawka@bisect.de>
References: <1329324340-13461-1-git-send-email-danny.kukawka@bisect.de>
	<1329324340-13461-3-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 15 Feb 2012 12:34:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Wed, 15 Feb 2012 17:45:40 +0100

> Use eth_hw_addr_random() instead of calling random_ether_addr()
> to set addr_assign_type correctly to NET_ADDR_RANDOM.
> 
> Reset the state to NET_ADDR_PERM as soon as the MAC get
> changed via .ndo_set_mac_address.
> 
> v2: adapt to renamed eth_hw_addr_random()
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied.
