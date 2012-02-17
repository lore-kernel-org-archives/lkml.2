Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2BQVFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:05:48 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54816 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab2BQVFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:05:46 -0500
Date: Fri, 17 Feb 2012 16:05:12 -0500 (EST)
Message-Id: <20120217.160512.672160259202281785.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: jdike@addtoit.com, dkukawka@suse.de, richard@nod.at,
        akpm@linux-foundation.org, jpirko@redhat.com,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] UML net: set addr_assign_type if
 random_ether_addr() used
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329493411-25750-11-git-send-email-danny.kukawka@bisect.de>
References: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de>
	<1329493411-25750-11-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 17 Feb 2012 13:05:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Fri, 17 Feb 2012 16:43:31 +0100

> Set addr_assign_type correctly to NET_ADDR_RANDOM in case
> a random MAC address was generated and assigned to the netdevice.
> 
> Return state from setup_etheraddr() about returning a random
> MAC address or not and check this state in eth_configure().
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied.
