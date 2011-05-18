Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1ERT6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:58:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56443 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab1ERT6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:58:50 -0400
Date: Wed, 18 May 2011 12:58:42 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, npiggin@kernel.dk,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: OOPS in configfs when doing d_delete
Message-ID: <20110518195842.GB5898@noexit.corp.google.com>
Mail-Followup-To: Jiri Slaby <jirislaby@gmail.com>,
	Jiri Slaby <jslaby@suse.cz>, npiggin@kernel.dk,
	Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <4D623C62.8030509@suse.cz>
 <20110221104359.GA18538@noexit>
 <4D6242AD.2090600@suse.cz>
 <20110222091415.GD30966@noexit>
 <4DCBA9A5.9040306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCBA9A5.9040306@gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 11:34:29AM +0200, Jiri Slaby wrote:
> On 02/22/2011 10:14 AM, Joel Becker wrote:
> > On Mon, Feb 21, 2011 at 11:47:09AM +0100, Jiri Slaby wrote:
> >>> 	I think you're right about the superfluous test, but I need more
> >>> investigation to see what's going on.  Thanks for the report.
> >>> 	What was causing attach_group() to fail?  Do you know?
> >>
> >> Dunno, I just modprobe'd the configfs example from Doc dir
> >> (configfs_example_macros).
> > 
> > 	I'm going to revisit the failed example (which shouldn't fail, I
> > would think).  Can you try the following patch to safely handle the
> > failure rather than crashing the kernel?
> > 
> > Joel
> 
> Hi, what's the status of this? (It's verified to work some time ago.)

	The runtime fix is queued up for mainline.  I'll be looking at
the example code fix for the next merge window.

Joel

-- 

"And yet I find,
 And yet I find repeating in my head.
 If I can't be my own, 
 I'd feel better dead."

			http://www.jlbec.org/
			jlbec@evilplan.org
