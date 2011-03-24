Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934368Ab1CXXca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 19:32:30 -0400
Received: from host171.canaca.com ([67.55.55.225]:45677 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1CXXc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 19:32:29 -0400
X-Greylist: delayed 29528 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Mar 2011 19:32:29 EDT
Message-ID: <fe471c05897776b7c26b9fd2603e3b76.squirrel@host171.canaca.com>
Date: Thu, 24 Mar 2011 11:20:19 -0400
Subject: 2.6.38 Regression: Nvidia GeForce8400 + i915 = Crash on Boot
From: simon@mungewell.org
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.20
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quick summary is that I have a GeForce8400 installed in a Thinkcenter with
on-board i915 graphics. 2.6.38 fails to boot, 2.6.37rcX is OK.

There appears to be some interaction between the nouveau and i915 drivers,
disabling the i915 enables system to boot. I am unable to disable on board
graphics in the BIOS (IBM special).

Full details/logs here:
https://bugs.launchpad.net/ubuntu/+bug/741434

Let me know if there is any further testing I can do to help,
Simon.



