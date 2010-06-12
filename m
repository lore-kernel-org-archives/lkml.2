Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab0FLHUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 03:20:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48736 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab0FLHUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 03:20:20 -0400
Date: Sat, 12 Jun 2010 09:19:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Divyesh Shah <dpshah@google.com>
Cc: jaxboe@fusionio.com, peterz@infradead.org, piotr@hosowicz.com,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] Remove preempt_enable/disable calls around
 sched_clock()
Message-ID: <20100612071950.GB29751@elte.hu>
References: <20100612023409.14850.76309.stgit@austin.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100612023409.14850.76309.stgit@austin.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3840]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Divyesh Shah <dpshah@google.com> wrote:

> calls in the block layer. This was a temporary fix added.

Not good, this commit reintroduces those ugly warnings, if someone happens to 
bisect straight into this commit.

	Ingo
