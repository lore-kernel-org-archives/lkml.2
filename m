Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab1CBGT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 01:19:26 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:58416 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab1CBGTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 01:19:25 -0500
Date: Wed, 2 Mar 2011 00:19:10 -0600
From: David Fries <david@fries.net>
To: Liang Bao <tim.bao@gmail.com>, Andrei Warkentin <andreiw@motorola.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH] work around for l2cap NULL dereference in
 l2cap_conn_start
Message-ID: <20110302061910.GE22204@spacedout.fries.net>
References: <20110211035309.GA22204@spacedout.fries.net>
 <20110214145649.GE2597@joana>
 <AANLkTi==Sh2yc2JjjY5t-NKxQexKPgPwNyWo4SMju92k@mail.gmail.com>
 <20110221043601.GB22204@spacedout.fries.net>
 <AANLkTi=b5UCdyc3ZtUFCx23uYygM7eRyGu-y_wdJ5JXi@mail.gmail.com>
 <20110227191545.GB2166@joana>
 <20110228050340.GC22204@spacedout.fries.net>
 <20110228173022.GC2165@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110228173022.GC2165@joana>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (SpacedOut.fries.net [127.0.0.1]); Wed, 02 Mar 2011 00:19:12 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 02:30:22PM -0300, Gustavo F. Padovan wrote:
> Hi David,
> 
> * David Fries <david@fries.net> [2011-02-27 23:03:40 -0600]:
> 
> > On Sun, Feb 27, 2011 at 04:15:45PM -0300, Gustavo F. Padovan wrote:
> > > I pushed the following patch to bluetooth-2.6 tree. It should fix the problem
> > > by avoiding connections to be accepted before a L2CAP info response comes:
> > 
> > Is
> > git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
> > the bluetooth-2.6 tree you mentioned?  I don't see your patch there.
> > As a side note, the inline patch in your e-mail has the tabs replaced by
> > spaces, once I changed them, it applied cleanly.
> > 
> > I first reverted to the base N900 kernel-power-2.6.28 46 (none of my
> > changes or debugging), it crashed as expected.  I then applied your
> > patch 743400e0, and it still crashed.  I added back the
> > l2cap_conn_start parent check and some debugging in af_bluetooth.c
> > dmesg debug output and patches follow.
> 
> I want to see a test with this patch and a recent kernel. We added many fixes
> to stack in the last two years. Can you test this scenario?

I'm sorry, but apparently not, at least this post says 2.6.37 isn't
going to happen for the N900 and Maemo.
http://forums.internettablettalk.com/showthread.php?t=70082

I tried 2.6.37-n900 from
git://gitorious.org/nokia-n900-kernel/nokia-n900-kernel.git anyway,
but the display visibly degrades like it isn't being updated and
doesn't apparently get any further.  I don't have anyway to debug it
further.

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
