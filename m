Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab1JAS3a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 14:29:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50830 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab1JAS3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 14:29:23 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=eaZrqAE3U5cA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=meVymXHHAAAA:8 a=u_aDJFwu1rNXsmjBiI8A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: w@1wt.eu, greg@kroah.com, linux-kernel@vger.kernel.org
Date: Sat, 01 Oct 2011 14:29:22 -0400
In-Reply-To: <20111001.141343.2293070262147973147.davem@davemloft.net>
References: <20110930235924.GA25176@kroah.com>
	 <20111001073533.GA18690@1wt.eu> <20111001180641.GD6309@home.goodmis.org>
	 <20111001.141343.2293070262147973147.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317493763.4588.70.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-01 at 14:13 -0400, David Miller wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Sat, 1 Oct 2011 14:06:41 -0400
> 
> > For my machine that is connected to the outside world, I have a script
> > that runs every night that checks for attacks. As bots constantly look
> > for port 22 and 80, they find my machine without issue. When my script
> > detects a bunch of ssh login attempts that fail, it will add that ip
> > address to the iptables DROP chain:
> 
> By running sshd on a different port, you'll avoid the login attempts
> as well as the overhead of the successful connection attempts.
> 
> I haven't allowed sshd to run on port 22 in more than 10 years.

I use to do that a long time ago, but I ran into issues because of it.
Can't remember the exact problem. Maybe it was places I went to that did
not allow outgoing connections to non official ports. Whatever it was,
it was annoying enough to put sshd back to 22.

I probably can go back to a non 22 port without much issue. I have added
a bunch of personal checks to this box that gives a report every day. I
may add more (from what was posted in this thread already). I also have
logwatch and rkhunter running, and just added chkrootkit now.

But moving the ssh port again may be a good idea. But I like stressing
your net filtering code ;)

-- Steve


