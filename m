Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526Ab2FOW4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:56:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:42989 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758359Ab2FOW4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:56:38 -0400
Date: Sat, 16 Jun 2012 00:56:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: ksummit-2012-discuss@lists.linux-foundation.org
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [ATTEND or not ATTEND] That's the question!
Message-ID: <alpine.LFD.2.02.1206152313310.3086@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear KS comittee,

like it or not, I really can't convice myself to adjust to the concept
of selfadvertising.

So I stick to the traditional way of proposing topics for KS and let
you decide whether the topic is interesting and my attendance is
required.

As you might know I'm wasting^spending a lot of time to fight the
steady growing insanity in the kernel code base. My current target is
cpu hotplug, but that's just a place holder for a more general
problem.

The steady increasing interest in Linux and the outcome of our quests
to convince involved parties to contribute leads to a few interesting
questions.

Thinking more about it, it all boils down to a single question:

 Are we (the kernel community and the current maintainer setup) able
 to cope with the inflood of patches?

  I for myself (admittedly I'm responsible for too much already, and
  I'm quite sure that other top level maintainers suffer in the same
  way) have a hard time to keep track of all the "interesting" bits
  which hit my inbox.

  Sure one might argue that I should delegate responsibility to others
  to lower my workload.

  I'd be happy to do that, really. I'm not a control freak and I
  really don't care about my patch count statistics (I never did, and
  I wish that this particular idiocy would have never been invented).

  Also I have delegated stuff to a large degree already.
  
  Though I have a hard time to find people who I can trust enough to
  take care of crucial core infrastructure bits.

  Aside of that I see a (steady increasing) repeated pattern that
  potential contributors propose totaly clueless patches to "solve" a
  particular problem.

  The time I spend on talking clue into those folks is at least an
  order of magnitude larger than coding it myself.

  I'm pretty sure that this is not caused by my inabilty to explain
  stuff to those folks, but by the insanity of managers who believe
  that adding a random number of random chosen so called "human
  resources" (I abhor that phrase) will solve the problems at hand.

  I know that the world and this industry in particular is driven by
  such insanities, but I can't commit myself to adhering to that.

So the main questions I want to raise on Kernel Summit are:

   - How do we cope with the need to review the increasing amount of
     (insane) patches and their potential integration?

   - How do we prevent further insanity to known problem spaces (like
     cpu hotplug) without stopping progress?

A side question, but definitely related is:

   - How do we handle "established maintainers" who are mainly
     interested in their own personal agenda and ignoring justified
     criticism just because they can?

Thanks,

	tglx
