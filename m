Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab1FLXLa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 19:11:30 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:59252 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab1FLXL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 19:11:28 -0400
Date: Sun, 12 Jun 2011 16:11:43 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: rcu_sched_state detected stall on CPU 0, 3.0-rc2
Message-ID: <20110612231143.GC11580@hexapodia.org>
References: <20110612195856.GA11580@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110612195856.GA11580@hexapodia.org>
X-Old-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Fingerprint: A5FC 6141 F76D B6B1 C81F  0FB7 AFA0 A45F ED3D 116D
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 12:58:56PM -0700, Andy Isaacson wrote:
> My Thinkpad x201s threw some errors (?) a few minutes after resuming
> from suspend-to-ram this morning.
> 
> [56415.672140] INFO: rcu_sched_state detected stall on CPU 0 (t=15000 jiffies)
> 
> Nothing jumps out of the backtraces at me.  Full dmesg and config
> attached.  This was my first StR since upgrading from 2.6.39, let's see
> if it fails again when I suspend after sending this email. :)

I haven't had a fully successful StR cycle yet (in 5 tries), although I
can't pin them all on RCU.  On try 2 it hung completely about 10 seconds
after I unlocked the screensaver, on try 3 it came back to a black
console, and on try 4 it didn't suspend at all (blinking moon LED but
battery LED and CPU fan still on).

-andy
