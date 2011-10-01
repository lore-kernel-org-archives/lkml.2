Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1JAEzA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 00:55:00 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38881 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233Ab1JAEyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 00:54:55 -0400
X-Sasl-enc: U6m5hkojOe9FH6J67YvArApPgn5tbxnCUXaF68MqpKW4 1317444894
Date: Fri, 30 Sep 2011 21:54:48 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
Message-ID: <20111001045448.GA24395@kroah.com>
References: <4E8655CD.90107@zytor.com>
 <20110930235924.GA25176@kroah.com>
 <20110930.211520.1376313955703692517.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930.211520.1376313955703692517.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 09:15:20PM -0400, David Miller wrote:
> From: Greg KH <greg@kroah.com>
> Date: Fri, 30 Sep 2011 16:59:24 -0700
> 
> > 1. Install the chkrootkit package from your distro repository and see if it
> >    reports anything.  If your distro doesn't have the chkroot package,
> >    download it from:
> > 	http://www.chkrootkit.org/
> > 
> >    Another tool is the ossec-rootcheck tool which can be found at:
> > 	http://www.ossec.net/main/rootcheck
> > 
> >    And another one is the rkhunter program:
> >    	http://www.rootkit.nl/projects/rootkit_hunter.html
> >    [Note, this tool has the tendancy to give false-positives on some
> >    Debian boxes, please read /usr/share/doc/rkhunter/README.Debian.gz if
> >    you run this on a Debian machine]
> 
> I quickly found that it gives false positives on Fedora15 too.
> 
> It thinks one is infected with Suckit.
> 
> It's check is essentially "strings /sbin/init | egrep HOME" which
> triggers with:
> 
> 	XDG_CONFIG_HOME
> 	XDG_DATA_HOME
> 	HOME=%s
> 
> I'm sure chkrootkit might be useful as a guide, but the seeming
> pervasiveness of it's false positives make it much less useful than it
> could be.

That's sad, but the combination of the three tools should give some
sense of what is going on if things are really valid or not, hopefully.

It was tough to write this in a way that would be applicable to the
large variety of systems we all use, so little differences like this
will happen.  Hopefully people take this as a guideline of things to do
to try to ensure the safety of a system.

thanks,

greg k-h
