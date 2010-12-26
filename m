Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab0LZWXF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 17:23:05 -0500
Received: from vms173011pub.verizon.net ([206.46.173.11]:38793 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab0LZWXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 17:23:04 -0500
Date: Sun, 26 Dec 2010 17:22:40 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Prevent users from disabling tickless
In-reply-to: <4D1266F5.8040702@am.sony.com>
Message-id: <alpine.LFD.2.00.1012261708070.2945@x980>
References: <20101221233942.GL1263@parisc-linux.org>
 <4D1266F5.8040702@am.sony.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why remove the ability to make the configuration choice?  Why not
> just add the info about performance impact to the help text and
> let me shoot myself in the foot (that is the unix way (tm)) if
> I desire to?

One can argue that configurability is one of the greatest
strengths of Linux.  OTOH, one can also argue that users
tend to get lost and hang themselves when given too
much rope; and that the burden of support and maintenance
of unnecessary config options squanders valuable resources.

Personally, I have two bugs filed against my code that
can be reproduced only in tickfull mode that almost
nobody uses.  Is it a good use of my time to be
distracted by by configurations that 0.01% use,
or focus on issues seen by the other 99.99%?

I'm in favor of deleting the config option,
and the cmdline option with it, and I applaud
Matthew for proposing such.

Len Brown, Intel Open Source Technology Center
