Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2LXQbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 11:31:33 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:63707 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2LXQba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 11:31:30 -0500
Date: Tue, 25 Dec 2012 00:30:05 +0800
From: Woody Wu <narkewoody@gmail.com>
To: kernelnewbies@kernelnewbies.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Porting problem: ndo_set_multicast_list removed
Message-ID: <20121224163005.GA3970@zuhnb712>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, list

I am porting an ethernet driver from 2.6.x to 3.7.1.  I found in the new
kernel, the ndo_set_multicast_list method in the net_device_ops had been
removed. What's the story behind?  Can I simply ignore this method
defined in an old driver?

Please also help to check the below code, is the list of the operations
defined for my driver enough or not?

const struct net_device_ops ax_netdev_ops = {
	.ndo_open		= mydriver_open,
	.ndo_stop		= mydriver_close,
	.ndo_start_xmit		= mydriver_start_xmit,
	.ndo_get_stats		= mydriver_get_stats,
	/*.ndo_set_multicast_list = mydriver_set_multicast_list,*/
	.ndo_set_mac_address 	= mydriver_set_mac_address,
};

Thanks in advance.

-- 
woody
I can't go back to yesterday - because I was a different person then.
