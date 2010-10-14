Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab0JNNfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 09:35:32 -0400
Received: from www.tglx.de ([62.245.132.106]:41346 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab0JNNfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 09:35:31 -0400
Date: Thu, 14 Oct 2010 15:34:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sqazi@google.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] hrtimer: Preserve timer state in
 remove_hrtimer()
In-Reply-To: <1287062583.29097.194.camel@twins>
Message-ID: <alpine.LFD.2.00.1010141530360.2655@localhost6.localdomain6>
References: <20101012142351.8485.21823.stgit@dungbeetle.mtv.corp.google.com>  <tip-f13d4f979c518119bba5439dd2364d76d31dcd3f@git.kernel.org> <1287062583.29097.194.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010, Peter Zijlstra wrote:

> On Thu, 2010-10-14 at 11:34 +0000, tip-bot for Salman Qazi wrote:
> > The bug was introduced with commit ca109491f (hrtimer: removing all ur
> > callback modes) in 2.6.29 
> 
> Not actually sure about that,. afaict its due to unlocking the base lock
> over the callback, which comes from 2d44ae4d7 (hrtimer: clean up
> cpu->base locking tricks), and existed before that in the special case
> of the scheduler tick (for which this problem is very unlikely to have
> ever triggered because we simply don't call start on it when its
> running).

Yeah, I got confused on that :)

 
> Anyway, the patch does look good, so


     tglx
