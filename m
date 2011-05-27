Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab1E0VN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 17:13:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55391 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab1E0VNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 17:13:55 -0400
Date: Fri, 27 May 2011 14:13:49 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, npiggin@kernel.dk,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: OOPS in configfs when doing d_delete
Message-ID: <20110527211349.GB30232@noexit.corp.google.com>
Mail-Followup-To: Jiri Slaby <jirislaby@gmail.com>,
	Jiri Slaby <jslaby@suse.cz>, npiggin@kernel.dk,
	Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <4D623C62.8030509@suse.cz>
 <20110221104359.GA18538@noexit>
 <4D6242AD.2090600@suse.cz>
 <20110222091415.GD30966@noexit>
 <4DCBA9A5.9040306@gmail.com>
 <20110518195842.GB5898@noexit.corp.google.com>
 <4DE013B6.9070801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE013B6.9070801@gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 11:12:22PM +0200, Jiri Slaby wrote:
> On 05/18/2011 09:58 PM, Joel Becker wrote:
> > On Thu, May 12, 2011 at 11:34:29AM +0200, Jiri Slaby wrote:
> >> On 02/22/2011 10:14 AM, Joel Becker wrote:
> >>> On Mon, Feb 21, 2011 at 11:47:09AM +0100, Jiri Slaby wrote:
> >>>>> 	I think you're right about the superfluous test, but I need more
> >>>>> investigation to see what's going on.  Thanks for the report.
> >>>>> 	What was causing attach_group() to fail?  Do you know?
> >>>>
> >>>> Dunno, I just modprobe'd the configfs example from Doc dir
> >>>> (configfs_example_macros).
> >>>
> >>> 	I'm going to revisit the failed example (which shouldn't fail, I
> >>> would think).  Can you try the following patch to safely handle the
> >>> failure rather than crashing the kernel?
> >>>
> >>> Joel
> >>
> >> Hi, what's the status of this? (It's verified to work some time ago.)
> > 
> > 	The runtime fix is queued up for mainline.  I'll be looking at
> > the example code fix for the next merge window.
> 
> The fixes for the examples were merged today after being some time in
> the -mm tree.

	I saw.  Thanks.

Joel

-- 

 One look at the From:
 understanding has blossomed
 .procmailrc grows
        - Alexander Viro

			http://www.jlbec.org/
			jlbec@evilplan.org
