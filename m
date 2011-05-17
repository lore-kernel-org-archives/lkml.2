Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab1EQK7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 06:59:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56852 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab1EQK7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 06:59:43 -0400
Date: Tue, 17 May 2011 12:59:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: Steve Munroe <sjmunroe@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
        libc-alpha@sourceware.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@MIT.EDU>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/5] Add a sysconf syscall
Message-ID: <20110517105912.GR22093@elte.hu>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
 <1305329059-2017-5-git-send-email-andi@firstfloor.org>
 <20110514065752.GA8827@elte.hu>
 <20110514163424.GU6008@one.firstfloor.org>
 <4DD14814.8080305@mit.edu>
 <20110516160810.GB25898@one.firstfloor.org>
 <OFCC4C610A.F152D00D-ON86257892.005E11F4-86257892.005E22BA@us.ibm.com>
 <4DD15E9B.2090809@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD15E9B.2090809@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> > Auxv is simpler yet.
> >
> 
> Yes simple and doesn't work.

And i've noticed one bug and three uncleanlinesses in your series.

See how destructive obstructionist comments that intentionally cut down on 
essential detail (which you do to gain a discussion advantage) are to the 
healthy flow of a discussion? Yet you are doing it all the time on lkml.

Why are you doing that, do you really enjoy inefficient discussions where you 
regularly throw in cryptic, ambiguous half-references to disrupt contrary 
opinion?

Please try to be more constructive in discussions.

Thanks,

	Ingo
