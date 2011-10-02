Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab1JBHuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 03:50:16 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45615 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751795Ab1JBHuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 03:50:11 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18PwA8xBOQPMHRCNNOO7qKIA2AnbMgoKfi85T+fFy
	ZyFHaMYogNARc8
Subject: Re: [Priority Inheritance] SCHED_FIFO or SCHED_RR?
From: Mike Galbraith <efault@gmx.de>
To: "Tadeus (Eus) Prastowo" <0x657573@googlemail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CAOVSwNEQzhzoKwnW5dZn8YsL5G+80_yvodmeJKBs2dSAxn7MsQ@mail.gmail.com>
References: <CAOVSwNFp=p3TmkfvB=BKq8b_jJVTywRspJSE3fhyKQaCfnzUvg@mail.gmail.com>
	 <CAOVSwNHoNuNBsuUecZhF0iWOL3PbJQt0cHR7Evf+gW6Q6SGA7Q@mail.gmail.com>
	 <1317447669.6337.24.camel@marge.simson.net>
	 <CAOVSwNEQzhzoKwnW5dZn8YsL5G+80_yvodmeJKBs2dSAxn7MsQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Oct 2011 09:50:07 +0200
Message-ID: <1317541807.6176.120.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-01 at 22:29 +0200, Tadeus (Eus) Prastowo wrote:
> On Sat, Oct 1, 2011 at 7:41 AM, Mike Galbraith <efault@gmx.de> wrote:
> > On Fri, 2011-09-30 at 21:12 +0200, Tadeus (Eus) Prastowo wrote:
> >> > Why should a SCHED_NORMAL task inheriting the priority of a SCHED_RR
> >> > task get the privilege of SCHED_FIFO task for running as long as it
> >> > wishes even when the task giving the inheritance does not have such
> >> > privilege?
> >
> > Existence of a critical section > slice would be the real problem, no?
> 
> No, it's not a problem because if a real-time system designer puts a
> real-time task under SCHED_RR, he will calculate the length of the
> critical section by taking into account the slice.

Submit a patch, and see if it flies.

	-Mike

