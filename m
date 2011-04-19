Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1DSSBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 14:01:24 -0400
Received: from www.xplot.org ([66.92.66.146]:46675 "EHLO www.xplot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab1DSSBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 14:01:23 -0400
From: Tim Shepard <shep@alum.mit.edu>
To: maciej.rutecki@gmail.com
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.39-rc3 udevadm settle timeout, many hdb events, interrupt storm 
In-reply-to: Your message of Sun, 17 Apr 2011 19:12:45 +0200.
             <201104171912.45583.maciej.rutecki@gmail.com> 
Date: Tue, 19 Apr 2011 14:01:20 -0400
Message-Id: <E1QCFEm-0005Oz-00@www.xplot.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




I have tried 2.6.39-rc4 and the same problem still exists.


(And the rate of the interrupt storm is over 300 interrupts per
 second.  I misstated that as over 1300 interrupts per second in my
 initial report, but the while loop output that I included accurately
 shows the rate of the interrupt storm.)

			-Tim Shepard
			 shep@alum.mit.edu
