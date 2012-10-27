Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab2J0EpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 00:45:04 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57924 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab2J0EpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 00:45:02 -0400
Date: Sat, 27 Oct 2012 00:44:56 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: =?utf-8?B?5p2o6IuP56uL?= Yang Su Li <suli@cs.wisc.edu>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
Message-ID: <20121027044456.GA2764@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Vladislav Bolkhovitin <vst@vlnb.net>,
	=?utf-8?B?5p2o6IuP56uL?= Yang Su Li <suli@cs.wisc.edu>,
	General Discussion of SQLite Database <sqlite-users@sqlite.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	drh@hwaci.com
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>
 <m2fw5mtffg.fsf_-_@firstfloor.org>
 <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
 <5086F5A7.9090406@vlnb.net>
 <20121025051445.GA9860@thunk.org>
 <508B3EED.2080003@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508B3EED.2080003@vlnb.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 09:54:53PM -0400, Vladislav Bolkhovitin wrote:
> What different in our positions is that you are considering storage
> as something you can connect to your desktop, while in my view
> storage is something, which stores data and serves them the best
> possible way with the best performance.

I don't get paid to make Linux storage work well for gold-plated
storage, and as far as I know, none of the purveyors of said gold
plated software systems are currently employing Linux file system
developers to make Linux file systems work well on said gold-plated
hardware.

As for what I might do on my own time, for fun, I can't afford said
gold-plated hardware, and personally I get a lot more satisfaction if
I know there will be a large number of people who benefit from my work
(it was really cool when I found out that millions and millions of
Android devices were going to be using ext4 :-), as opposed to a very
small number of people who have paid $$$ to storage vendors who don't
feel it's worthwhile to pay core Linux file system developers to
leverage their hardware.  Earlier, you were bemoaning why Linux file
system developers weren't paying attention to using said fancy SCSI
features.  Perhaps now you'll understand better it's not happening?

> Price doesn't matter here, because it's completely different topic.

It matters if you think I'm going to do it on my own time, out of my
own budget.  And if you think my employer is going to choose to use
said hardware, price definitely matters.  I consider engineering to be
the art of making tradeoffs, and price is absolutely one of the things
that we need to trade off against other goals.

It's rare that you get to design something where performance matters
above all else.  Maybe it's that way if you're paid by folks whose job
it is to destablize the world's financial markets by pushing the holes
into the right half plane (i.e., high frequency trading :-).  But for
the rest of the world, price absolutely matters.

     	    	   	 	    - Ted

P.S.  All of the storage I have access to at home is SATA.  If someone
would like to change that and ship me free hardware, as long as it
doesn't require three-phase power (or require some exotic interconnect
which is ghastly expensive and which you are also not going to provide
me for free), do contact me off-line.  :-)
