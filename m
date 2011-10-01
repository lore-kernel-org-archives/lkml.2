Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1JASfE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 14:35:04 -0400
Received: from 1wt.eu ([62.212.114.60]:33326 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab1JASfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 14:35:00 -0400
Date: Sat, 1 Oct 2011 20:34:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Miller <davem@davemloft.net>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: kernel.org status: hints on how to check your machine for intrusion
Message-ID: <20111001183448.GD18690@1wt.eu>
References: <20110930235924.GA25176@kroah.com> <20111001073533.GA18690@1wt.eu> <20111001180641.GD6309@home.goodmis.org> <20111001.141343.2293070262147973147.davem@davemloft.net> <1317493763.4588.70.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317493763.4588.70.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 02:29:22PM -0400, Steven Rostedt wrote:
> On Sat, 2011-10-01 at 14:13 -0400, David Miller wrote:
> > From: Steven Rostedt <rostedt@goodmis.org>
> > Date: Sat, 1 Oct 2011 14:06:41 -0400
> > 
> > > For my machine that is connected to the outside world, I have a script
> > > that runs every night that checks for attacks. As bots constantly look
> > > for port 22 and 80, they find my machine without issue. When my script
> > > detects a bunch of ssh login attempts that fail, it will add that ip
> > > address to the iptables DROP chain:
> > 
> > By running sshd on a different port, you'll avoid the login attempts
> > as well as the overhead of the successful connection attempts.
> > 
> > I haven't allowed sshd to run on port 22 in more than 10 years.
> 
> I use to do that a long time ago, but I ran into issues because of it.
> Can't remember the exact problem. Maybe it was places I went to that did
> not allow outgoing connections to non official ports. Whatever it was,
> it was annoying enough to put sshd back to 22.

443 is pretty nice for connecting from unexpected places ;-)

> I probably can go back to a non 22 port without much issue. I have added
> a bunch of personal checks to this box that gives a report every day. I
> may add more (from what was posted in this thread already). I also have
> logwatch and rkhunter running, and just added chkrootkit now.
> 
> But moving the ssh port again may be a good idea. But I like stressing
> your net filtering code ;)

BTW ipset is particularly suited for this.

Regards,
Willy

