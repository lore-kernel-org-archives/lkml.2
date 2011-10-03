Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1JCJ4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:56:54 -0400
Received: from rackplans.net ([209.44.101.17]:40418 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754582Ab1JCJ4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:56:41 -0400
Date: Mon, 3 Oct 2011 05:47:26 -0400 (EDT)
From: gmack@innerfire.net
X-X-Sender: gmack@mtl.rackplans.net
To: Steven Rostedt <rostedt@goodmis.org>
cc: David Miller <davem@davemloft.net>, w@1wt.eu, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
In-Reply-To: <1317494738.4588.78.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1110030539390.7763@mtl.rackplans.net>
References: <20110930235924.GA25176@kroah.com>  <20111001073533.GA18690@1wt.eu> <20111001180641.GD6309@home.goodmis.org>  <20111001.141343.2293070262147973147.davem@davemloft.net> <1317494738.4588.78.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Date: Sat, 01 Oct 2011 14:45:38 -0400
> From: Steven Rostedt <rostedt@goodmis.org>
> To: David Miller <davem@davemloft.net>
> Cc: w@1wt.eu, greg@kroah.com, linux-kernel@vger.kernel.org
> Subject: Re: kernel.org status: hints on how to check your machine for
>     intrusion
> 
> On Sat, 2011-10-01 at 14:40 -0400, Steven Rostedt wrote:
> > OK, I decided to attach the perl script anyway. It is very crude, and
> > really needs to be cleaned up for generic use.
> > 
> 
> I've just been pointed to:
> 
> http://www.fail2ban.org/wiki/index.php/Main_Page
> 
> This looks like something similar.
> 
> You see, the reason I posted this tool is because I was sure people will
> point me to better ones that do the same thing (and more!)   ;)
> 

The nice thing about fail2ban is that you can use it to montitor other 
ports since many bots are now doing ftp/smtp sasl/imap/imaps/pop3/pop3s 
scans to find system accounts and then use the result for an ssh login.

As a warning though, at least on debian the SMTP SASL regex is non 
functional and I haven't had time to work out a working one so hopefully 
if someone has one it would be helpful. A fix for this is doubly important 
since the SASL package has a memory leak on failed login that they have 
known about for at least 3 years but haven't bothered fixing.  A scanning 
bot can take up several gigs of memory in about an hour.

	Gerhard


--
Gerhard Mack

gmack@innerfire.net

<>< As a computer, I find your faith in technology amusing.
