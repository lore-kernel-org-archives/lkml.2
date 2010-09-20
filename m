Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab0ITSD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:03:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:41207 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab0ITSD6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:03:58 -0400
Subject: Re: [RFC][PATCH 0/2] PF_flags cleaups
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <AANLkTikcnY7B-+2XYXronUexhgx=gQJfVtLi=RKjP1fs@mail.gmail.com>
References: <20100920151334.569154707@chello.nl>
	 <AANLkTinjVNddRYDUBnVZ67QDEPGrpj4dmW5BMwq2+ozP@mail.gmail.com>
	 <1284998339.2275.738.camel@laptop>
	 <AANLkTikcnY7B-+2XYXronUexhgx=gQJfVtLi=RKjP1fs@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Sep 2010 20:03:34 +0200
Message-ID: <1285005814.2275.790.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 09:15 -0700, Linus Torvalds wrote:
> On Mon, Sep 20, 2010 at 8:58 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > One point though, I noticed we actually expose p->flags to userspace,
> > which basically makes PF_flags an ABI, do we care?
> 
> Hmm. Where? And no, I don't think we care. But let's keep it in mind
> if something subtle breaks in surprising ways.

fs/proc/array.c:do_task_stat()

I'll rework the patches and simply move the bits around to another
field. We'll see what falls over.. :-)
