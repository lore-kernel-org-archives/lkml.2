Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab1FGQZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:25:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab1FGQZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:25:09 -0400
Date: Tue, 7 Jun 2011 12:24:54 -0400
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: random hangs during boot in 3.0-rc
Message-ID: <20110607162454.GA16521@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20110607034617.GA27980@redhat.com>
 <20110607110102.GE21356@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607110102.GE21356@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 01:01:02PM +0200, Ingo Molnar wrote:
 > 
 > * Dave Jones <davej@redhat.com> wrote:
 > 
 > > I have two machines that occasionally (like 1 in 10 boots or so) 
 > > hang solid during boot-up.  Happens in different places, but 
 > > usually either when loading the microcode driver, or while doing a 
 > > fsck.
 > 
 > I think this commit in tip:sched/urgent will fix it:
 > 
 >   f2513cde93f0: lockdep: Fix lock_is_held() on recursion
 > 
 > Will send it to Linus later today.

Indeed. Looks like that does fix the problem. 
I've done a number of reboots on one of the affected machines this morning,
without any hangs.

	Dave

