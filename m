Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab1KBKuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 06:50:39 -0400
Received: from gimli.pitney-fabs.co.uk ([87.106.140.52]:43387 "EHLO
	gimli.pitney-fabs.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab1KBKug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 06:50:36 -0400
X-Greylist: delayed 2181 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Nov 2011 06:50:36 EDT
Date: Wed, 2 Nov 2011 10:14:04 +0000
From: Andrew Walrond <andrew@walrond.org>
To: linux-kernel@vger.kernel.org
Subject: eth0/1 swapped places after kernel Upgrade 3.0.8 -> 3.1.0 (and udev
 172 -> 174)
Message-ID: <20111102101404.GA5195@andrew-xps.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is a udev or kernel issue, or indeed whether I
 should expect these devices to have persistent naming at all
 without some udev configuration of my own, but I thought I'd
 report it just in case it's useful.

Output from lspci:

03:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
07:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)

Andrew Walrond

