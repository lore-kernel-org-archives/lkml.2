Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab1B1R3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 12:29:51 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50861 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab1B1R3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 12:29:50 -0500
Date: Mon, 28 Feb 2011 14:30:22 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: David Fries <david@fries.net>
Cc: Liang Bao <tim.bao@gmail.com>, Andrei Warkentin <andreiw@motorola.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH] work around for l2cap NULL dereference in
 l2cap_conn_start
Message-ID: <20110228173022.GC2165@joana>
Mail-Followup-To: David Fries <david@fries.net>,
	Liang Bao <tim.bao@gmail.com>,
	Andrei Warkentin <andreiw@motorola.com>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	Feng Tang <feng.tang@intel.com>
References: <20110211035309.GA22204@spacedout.fries.net>
 <20110214145649.GE2597@joana>
 <AANLkTi==Sh2yc2JjjY5t-NKxQexKPgPwNyWo4SMju92k@mail.gmail.com>
 <20110221043601.GB22204@spacedout.fries.net>
 <AANLkTi=b5UCdyc3ZtUFCx23uYygM7eRyGu-y_wdJ5JXi@mail.gmail.com>
 <20110227191545.GB2166@joana>
 <20110228050340.GC22204@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110228050340.GC22204@spacedout.fries.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

* David Fries <david@fries.net> [2011-02-27 23:03:40 -0600]:

> On Sun, Feb 27, 2011 at 04:15:45PM -0300, Gustavo F. Padovan wrote:
> > I pushed the following patch to bluetooth-2.6 tree. It should fix the problem
> > by avoiding connections to be accepted before a L2CAP info response comes:
> 
> Is
> git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
> the bluetooth-2.6 tree you mentioned?  I don't see your patch there.
> As a side note, the inline patch in your e-mail has the tabs replaced by
> spaces, once I changed them, it applied cleanly.
> 
> I first reverted to the base N900 kernel-power-2.6.28 46 (none of my
> changes or debugging), it crashed as expected.  I then applied your
> patch 743400e0, and it still crashed.  I added back the
> l2cap_conn_start parent check and some debugging in af_bluetooth.c
> dmesg debug output and patches follow.

I want to see a test with this patch and a recent kernel. We added many fixes
to stack in the last two years. Can you test this scenario?

-- 
Gustavo F. Padovan
http://profusion.mobi
