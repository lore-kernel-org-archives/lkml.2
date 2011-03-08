Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab1CHWQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 17:16:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37976 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab1CHWQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 17:16:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [linux-pm] Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
Date: Tue, 8 Mar 2011 23:16:59 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.1102221029100.1968-100000@iolanthe.rowland.org> <201103082312.26675.rjw@sisk.pl> <4D76AA2C.2010805@gmail.com>
In-Reply-To: <4D76AA2C.2010805@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103082316.59901.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 08, 2011, Jiri Slaby wrote:
> On 03/08/2011 11:12 PM, Rafael J. Wysocki wrote:
> > On Tuesday, March 08, 2011, Jiri Slaby wrote:
> >> On 03/08/2011 08:25 PM, Rafael J. Wysocki wrote:
> >>> On Tuesday, March 08, 2011, Jiri Slaby wrote:
> >>>> On 02/22/2011 04:36 PM, Alan Stern wrote:
> >>>>> By the way, are you booting with no_console_suspend?  And do you do 
> >>>>> "echo 8 >/proc/sys/kernel/printk" (or equivalently, Alt-SysRq-8) before 
> >>>>> suspending?
> >>>>
> >>>> Unfortunately there are no messages at all.
> >>>>
> >>>> Rafael, this is a Factory with intel gfx (modesetting). Do pm-utils
> >>>> switch a console in such case? And if yes, to which one?
> >>>
> >>> pm-utils don't, but s2ram does, I'm not sure from the top of my head to
> >>> which one, though.
> >>>
> >>> If you use a KMS driver (I get you do), please just "chmod a-x /usr/sbin/s2ram".
> >>
> >> Yeah, I meant kernel modesetting, of course. Sorry for the confusion.
> >>
> >> I don't have /usr/sbin/s2ram.
> > 
> > Ah.  So it's gone from Factory?  Interesting.
> 
> I don't know, maybe it's in suspend package which I don't have installed.

Hm.  So you use the in-kernel hibernate code?

The one in the suspend package is generally faster.
