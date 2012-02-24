Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab2BXUn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 15:43:57 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:39921 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916Ab2BXUny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:43:54 -0500
Date: Fri, 24 Feb 2012 15:43:35 -0500 (EST)
Message-Id: <20120224.154335.577711354132386075.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: danny.kukawka@bisect.de, ralf@linux-mips.org, dkukawka@suse.de,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] rose: check given MAC address, if invalid return
 -EADDRNOTAVAIL
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120224161358.17df7421@pyramind.ukuu.org.uk>
References: <1330099282-4588-1-git-send-email-danny.kukawka@bisect.de>
	<1330099282-4588-13-git-send-email-danny.kukawka@bisect.de>
	<20120224161358.17df7421@pyramind.ukuu.org.uk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 24 Feb 2012 12:43:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 24 Feb 2012 16:13:58 +0000

> On Fri, 24 Feb 2012 17:01:22 +0100
> Danny Kukawka <danny.kukawka@bisect.de> wrote:
> 
>> Check if given address is valid in .ndo_set_mac_address/
>> rose_set_mac_address(), if invalid return -EADDRNOTAVAIL as
>> eth_mac_addr() already does if is_valid_ether_addr() fails.
> 
> This patch series looks wrong - you cannot go blindly applying ethernet
> mac address tests to device drivers without checking if they are using
> 802.11 type addressing at the physical level.

Right.
