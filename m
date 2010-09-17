Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab0IQEqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 00:46:05 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:9666 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750860Ab0IQEqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 00:46:04 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/r5dp2vD7roY52y+hgSWDG+BUz2kK+KbIgcBZSNM
	pVyX/+29n6bGJc
Subject: Re: 2.6.32.y stable kernel regression with taskset
From: Mike Galbraith <efault@gmx.de>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Wright <john.wright@hp.com>
In-Reply-To: <4C92719E.5070103@oracle.com>
References: <4C9114A6.6040500@oracle.com>
	 <1284608712.7403.10.camel@marge.simson.net> <20100916144216.GA4794@suse.de>
	 <4C92719E.5070103@oracle.com>
Content-Type: text/plain
Date: Fri, 17 Sep 2010 06:46:06 +0200
Message-Id: <1284698766.8721.32.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 12:35 -0700, Yinghai Lu wrote:
> On 09/16/2010 07:42 AM, Greg KH wrote:
> > On Thu, Sep 16, 2010 at 05:45:12AM +0200, Mike Galbraith wrote:

> >>> git bisect report:
> >>>
> >>> c6fc81afa2d7ef2f775e48672693d8a0a8a7325d is the first bad commit
> >>> commit c6fc81afa2d7ef2f775e48672693d8a0a8a7325d
> >>> Author: John Wright <john.wright@hp.com>
> >>> Date:   Tue Apr 13 16:55:37 2010 -0600
> >>>
> >>>     sched: Fix a race between ttwu() and migrate_task()
> >>
> >> Known issue.  There's a sched series for 32-stable in the pipeline.
> > 
> > Yes, sorry, I'm working my way through to them, hope to have them
> > finished and applied soon.
> > 
> 
> why not just revert that patch?

Because it exists.  If revert would fix the problem, neither the commit
in question nor the upstream commit it mentions would exist.

	-Mike

