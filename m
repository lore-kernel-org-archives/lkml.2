Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab0DZMXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 08:23:23 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:58632 "EHLO
	mail.cs.fsu.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752429Ab0DZMXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 08:23:22 -0400
X-Greylist: delayed 1581 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Apr 2010 08:23:22 EDT
Date: Mon, 26 Apr 2010 07:56:58 -0400
From: Ted Baker <baker@cs.fsu.edu>
To: raj@ece.cmu.edu, jayhawk@soe.ucsc.edu, a.p.zijlstra@chello.nl,
       raistlin@linux.it, niehaus@ittc.ku.edu, henrik@austad.us,
       linux-kernel@vger.kernel.org, mingo@elte.hu, billh@gnuppy.monkey.org,
       linux-rt-users@vger.kernel.org, fabio@gandalf.sssup.it,
       anderson@cs.unc.edu, tglx@linutronix.de, dhaval.giani@gmail.com,
       cucinotta@sssup.it, lipari@retis.sssup.it
Cc: baker.tlh@comcast.net
Subject: Re: [Fwd: Re: RFC for a new Scheduling policy/class in the Linux-kernel]
Message-ID: <20100426115658.GA21346@cs.fsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have not seen any more e-mail on this.  How is it going?  Is there any
chance of rolling in some corrections for the SCHED_SPORADIC treatment?  In
particular, could we have a DO_NOT_RUN priority, that is guaranteed to
prevent a task from running at all?

For more detail, see http://ww2.cs.fsu.edu/~stanovic/papers/rtas10.pdf .

Ted
