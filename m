Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab2GTDtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 23:49:21 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53438 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751768Ab2GTDtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 23:49:17 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+pX8Q1lj6pVye9YwppVbO2ZNwd1kyUGtHQDE5l+8
	mF/E7jhzHp+xvX
Message-ID: <1342756153.7432.9.camel@marge.simpson.net>
Subject: Re: [PATCH RT 00/12] [ANNOUNCE] 3.0.36-rt58-rc1 stable review
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Fri, 20 Jul 2012 05:49:13 +0200
In-Reply-To: <1342706530.12353.27.camel@gandalf.stny.rr.com>
References: <20120718223910.898476857@goodmis.org>
	 <1342670426.7342.8.camel@marge.simpson.net>
	 <1342703141.12353.24.camel@gandalf.stny.rr.com>
	 <1342705899.7342.42.camel@marge.simpson.net>
	 <1342706530.12353.27.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 10:02 -0400, Steven Rostedt wrote: 
> On Thu, 2012-07-19 at 15:51 +0200, Mike Galbraith wrote:
> 
> > Every kernel I've fed you script to has died sooner or later, so I wish
> > him fair sailing.  Here there be sea monsters ;-)
> 
> I'm curious. Can my script bring down a non-rt kernel?

Yeah, it took a couple non-rt (and virgin) kernels down on my 64 core
box.

-Mike

