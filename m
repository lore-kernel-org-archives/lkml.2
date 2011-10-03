Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab1JCJ4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:56:47 -0400
Received: from rackplans.net ([209.44.101.17]:40417 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753964Ab1JCJ4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:56:41 -0400
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Oct 2011 05:56:41 EDT
Date: Mon, 3 Oct 2011 05:49:52 -0400 (EDT)
From: gmack@innerfire.net
X-X-Sender: gmack@mtl.rackplans.net
To: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>
cc: Steven Rostedt <rostedt@goodmis.org>, Willy Tarreau <w@1wt.eu>,
        Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
In-Reply-To: <4E878F01.7010604@kingswood-consulting.co.uk>
Message-ID: <alpine.DEB.2.00.1110030548020.7763@mtl.rackplans.net>
References: <4E8655CD.90107@zytor.com> <20110930235924.GA25176@kroah.com> <20111001073533.GA18690@1wt.eu> <20111001180641.GD6309@home.goodmis.org> <4E878F01.7010604@kingswood-consulting.co.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Oct 2011, Frank A. Kingswood wrote:
> On 01/10/11 19:06, Steven Rostedt wrote:
> > On Sat, Oct 01, 2011 at 09:35:33AM +0200, Willy Tarreau wrote:
> > > 
> > For my machine that is connected to the outside world, I have a script
> > that runs every night that checks for attacks. As bots constantly look
> > for port 22 and 80, they find my machine without issue. When my script
> > detects a bunch of ssh login attempts that fail, it will add that ip
> > address to the iptables DROP chain:
> > 
> > # iptables -L -n | grep DROP | wc -l
> > 2656
> > 
> > I've picked up quite a few ;)
> > 
> > This script only runs and scans once at night. Probably better to have
> > it run more often.
> 
> Limiting SSH accesses to a few a minute (failed or not) is useful to block
> many password guess attacks. I set up mine a long time ago following this
> article using "recent" matches in iptables:
> 
> http://www.debian-administration.org/articles/187
> 
> You'll want to set the same rules for ipv6.
> 
> This won't stop low frequency and distributed attacks, and sometimes but
> extremely rarely I find myself connecting more quickly than the rate limit.

Too easy to hit the rate limit if you work in an office full of people who 
use scp for file uploads.

	Gerhard


--
Gerhard Mack

gmack@innerfire.net

<>< As a computer, I find your faith in technology amusing.
