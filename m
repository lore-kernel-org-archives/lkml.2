Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab0ITQXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 12:23:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756841Ab0ITQXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 12:23:16 -0400
MIME-Version: 1.0
In-Reply-To: <1284998339.2275.738.camel@laptop>
References: <20100920151334.569154707@chello.nl> <AANLkTinjVNddRYDUBnVZ67QDEPGrpj4dmW5BMwq2+ozP@mail.gmail.com>
 <1284998339.2275.738.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Sep 2010 09:15:29 -0700
Message-ID: <AANLkTikcnY7B-+2XYXronUexhgx=gQJfVtLi=RKjP1fs@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/2] PF_flags cleaups
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 8:58 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> One point though, I noticed we actually expose p->flags to userspace,
> which basically makes PF_flags an ABI, do we care?

Hmm. Where? And no, I don't think we care. But let's keep it in mind
if something subtle breaks in surprising ways.

                                Linus
