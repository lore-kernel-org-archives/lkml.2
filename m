Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab0E1RBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:01:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44048 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758473Ab0E1RBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:01:33 -0400
Date: Fri, 28 May 2010 13:01:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Brian Swetland <swetland@google.com>, Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, <tytso@mit.edu>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100528173151.2c5f6fde@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.1005281257040.1939-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010, Alan Cox wrote:

> > I think Arve's concern was the representation of the "I care, but only
> > a little" or "just low enough to ensure threads must run" level which
> > is what suspend blockers would map to (low enough to ensure we
> > shouldn't halt the world but not necessarily implying a hard latency
> > constraint beyond that).
> 
> That's why I suggested "manyana" (can't get accents for mañana in a
> define) or perhaps "dreckly"[1]. They are both words that mean "at some
> point" but in a very very vague and 'relax it'll happen eventually' sense.

A USA-style equivalent phrase might be "Real Soon Now".  Except that it 
conveys a strong implication that the event will never happen...

> > That makes sense -- and as I've mentioned elsewhere, we're really not
> > super picky about naming -- if it turns out that
> > wakelocks/suspendblockers were shorthand for "request a qos constraint
> > that ensures that threads are running", we'll be able to get things
> > done just as well as we do now.
> 
> Cool. I think they are or at least they are close enough that nobody will
> notice the join ;)

Why are suspend blockers needed if you're going to put all untrusted 
apps in a cgroup and freeze/stop them?  Or is that not what you're 
planning to do?

ALan Stern

