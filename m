Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab1KIAkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 19:40:21 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47519 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754063Ab1KIAkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 19:40:19 -0500
X-Sasl-enc: XhAhY4OttiTkqLFgOw8EBNegZ4xGKCN804woGrUohK2J 1320799218
Date: Tue, 8 Nov 2011 16:40:13 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        Luis Henriques <henrix@camandro.org>,
        Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, stable@vger.kernel.org
Subject: Re: Linus GIT - INFO: possible circular locking dependency detected
Message-ID: <20111109004013.GA30562@kroah.com>
References: <CAHFgRy8S0xLfhZxTUOEH5A0PL_Fb79-0-gmbQ=9h2D-xMqt1hA@mail.gmail.com>
 <20111103204930.GA3599@hades>
 <20111105093146.GA14338@albatros>
 <20111108155716.33c04ce1.akpm@linux-foundation.org>
 <20111109001723.GA26225@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109001723.GA26225@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 04:17:23PM -0800, Greg KH wrote:
> On Tue, Nov 08, 2011 at 03:57:16PM -0800, Andrew Morton wrote:
> > On Sat, 5 Nov 2011 13:31:46 +0400
> > Vasiliy Kulikov <segoon@openwall.com> wrote:
> > 
> > > (cc'ed Andrew and Alexey)
> > > 
> > > On Thu, Nov 03, 2011 at 20:49 +0000, Luis Henriques wrote:
> > > > On Thu, Nov 03, 2011 at 11:57:20AM -0400, Miles Lane wrote:
> > > > ...
> > > > 
> > > > I'm hitting the exact same problem, using a minimal .config file (can send
> > > > it if required), by just running "find /".
> > > > 
> > > > I have bisected the problem and found that commit
> > > > aa6afca5bcaba8101f3ea09d5c3e4100b2b9f0e5 seems to be the cause of it.
> > 
> > Well, let's tell the -stable maintainer(s?)
> 
> It's just me.  And my script-bots, but they are all controlled by me in
> the end.  Hopefully....
> 
> > that aa6afca5bca ("proc:
> > fix races against execve() of /proc/PID/fd**") is known to cause a
> > regression.
> 
> Ok, I'll go delete it from the stable queues for now.

Now removed.

