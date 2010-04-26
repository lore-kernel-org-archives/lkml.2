Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab0DZS3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 14:29:08 -0400
Received: from 8bytes.org ([88.198.83.132]:38119 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab0DZS3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 14:29:06 -0400
Date: Mon, 26 Apr 2010 20:29:03 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Ted Baker <baker@cs.fsu.edu>
Cc: raj@ece.cmu.edu, jayhawk@soe.ucsc.edu, a.p.zijlstra@chello.nl,
       raistlin@linux.it, niehaus@ittc.ku.edu, henrik@austad.us,
       linux-kernel@vger.kernel.org, mingo@elte.hu, billh@gnuppy.monkey.org,
       linux-rt-users@vger.kernel.org, fabio@gandalf.sssup.it,
       anderson@cs.unc.edu, tglx@linutronix.de, dhaval.giani@gmail.com,
       cucinotta@sssup.it, lipari@retis.sssup.it, baker.tlh@comcast.net
Subject: Re: [Fwd: Re: RFC for a new Scheduling policy/class in the
	Linux-kernel]
Message-ID: <20100426182903.GA14542@8bytes.org>
References: <20100426115658.GA21346@cs.fsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100426115658.GA21346@cs.fsu.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 07:56:58AM -0400, Ted Baker wrote:
> I have not seen any more e-mail on this.  How is it going?  Is there any
> chance of rolling in some corrections for the SCHED_SPORADIC treatment?  In
> particular, could we have a DO_NOT_RUN priority, that is guaranteed to
> prevent a task from running at all?

Sorry for asking a maybe stupid question, but what is this good for and
what is the benefit over SIGSTOP?

	Joerg

