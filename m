Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab2DEPQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:16:15 -0400
Received: from linux-sh.org ([111.68.239.195]:56002 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226Ab2DEPQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 11:16:13 -0400
Date: Fri, 6 Apr 2012 00:15:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, dhowells@redhat.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH 07/11] sh: fix several build failures from system.h fallout
Message-ID: <20120405151558.GD23761@linux-sh.org>
References: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com> <1333312727-11428-8-git-send-email-paul.gortmaker@windriver.com> <20120402010048.GA21647@linux-sh.org> <4F79ECD9.6000108@windriver.com> <20120403095754.a70f38eb70766580843debc7@canb.auug.org.au> <CAP=VYLpxEvcQv=AOZCU46PQrVn04MC7_Jhodba9z-mmj9XamSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP=VYLpxEvcQv=AOZCU46PQrVn04MC7_Jhodba9z-mmj9XamSw@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 10:49:30PM -0400, Paul Gortmaker wrote:
> [sorry for empty mail, pilot error]
> 
> On Mon, Apr 2, 2012 at 7:57 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> >
> > I used to have sh-current and sh trees (and rmobile-current and rmobile)
> > trees in linux-next, but they have not been resurrected since the
> > kernel.org problems last year ...
> >
> > They were all branches of
> > git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git which is
> > still listed in MAINTAINERS but does not exist :-(
> >
> > Paul M, to you have an alternate place I can fetch from?
> 
> Hi Paul M.
> 
> Is this the tree Stephen should be using in linux-next?
> 
>         git://github.com/pmundt/linux-sh.git sh-latest
> 
Yes, that's the current one for sh stuff for now. The rmobile stuff is
going through the ARM SoC tree nowadays, so that shouldn't matter.  I
haven't bothered getting the trees back on kernel.org yet, so I haven't
updated the MAINTAINERS entry, but will probably do so in the future.
