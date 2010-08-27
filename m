Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab0H0Tm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 15:42:27 -0400
Received: from wsip-70-167-241-26.dc.dc.cox.net ([70.167.241.26]:59093 "EHLO
	firewall1" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752040Ab0H0TmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 15:42:24 -0400
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linux-kernel@vger.kernel.org
Cc: Kyle Moffett <kyle@moffetthome.net>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        netdev@vger.kernel.org
Subject: [RFC] Support for unidirectional ethernet links
Date: Fri, 27 Aug 2010 15:42:16 -0400
Message-Id: <1282938138-17844-1-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm in the process of dusting off some old unidirectional fiber link
patches as part of support for a new custom hardware chassis.

Specifically, a critical piece of the hardware is unidirectional fiber
connections between independent computers, with data transmission
performed using UDP to a static ARP entry.

These first 2 RFC patches provide support for off-the-shelf gigabit
sky2 boards.  I also have another fairly trivial patch to "ethtool"
which enables it to configure the new ethtool values.

If these patches are acceptable, I'm going to polish up and refine a
more invasive series which cleans up and extends some of the PHY
ethtool handling to allow PHYs to handle the unidirectional modes in
a driver-specific way.

Cheers,
Kyle Moffett

