Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab0FUHFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 03:05:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50939 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab0FUHFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 03:05:33 -0400
Date: Mon, 21 Jun 2010 09:05:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH] cfq-iosched: Fixed boot warning with BLK_CGROUP=y and
 CFQ_GROUP_IOSCHED=n
Message-ID: <20100621070517.GA31535@elte.hu>
References: <20100618143947.GA8431@redhat.com>
 <20100620081016.GA5365@elte.hu>
 <20100620225622.GA12368@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100620225622.GA12368@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1940]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vivek Goyal <vgoyal@redhat.com> wrote:

> On Sun, Jun 20, 2010 at 10:10:16AM +0200, Ingo Molnar wrote:
> > 
> > * Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > Hi Jens,
> > > 
> > > Few days back Ingo noticed a CFQ boot time warning. This patch fixes it.
> > 
> > Hm, have you tested it? This bit:
> 
> I did compile and boot testing. Booted with CFQ_GROUP_IOSCHED=n to make
> sure warning seen by you is gone. [...]

It was not a build warning, it was a build failure. (Even if it built the 
recursion would cause a crash on bootup.) Will try your newer patch too.

Thanks,

	Ingo
