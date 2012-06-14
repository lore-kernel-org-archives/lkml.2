Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab2FNI4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:56:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41378 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab2FNI4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:56:30 -0400
Date: Thu, 14 Jun 2012 10:56:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com
Subject: Re: [PATCH 2/4] x86: Track minimum microcode revision globally v2
Message-ID: <20120614085624.GC2964@gmail.com>
References: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
 <1339618842-26636-3-git-send-email-andi@firstfloor.org>
 <1339623261.8980.65.camel@twins>
 <20120613213915.GE32604@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613213915.GE32604@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> On Wed, Jun 13, 2012 at 11:34:21PM +0200, Peter Zijlstra wrote:
> > On Wed, 2012-06-13 at 13:20 -0700, Andi Kleen wrote:
> > > +       for_each_online_cpu (i)
> > 
> > # git grep "for_each_[^(]*(" arch/x86/ | wc -l
> > 315
> > # git grep "for_each_[^(]* (" arch/x86/ | wc -l
> > 0
> 
> Well, it's a for loop. Do you want me to grep for all for 
> loops. We've never written for loops without space. Loops 
> without space do not make any sense to me.

Good riddance, what Peter showed you is the standard Linux 
kernel coding style:

  $ git grep "for_each_[^(]*(" kernel/ | wc -l
  758
  $ git grep "for_each_[^(]* (" kernel/ | wc -l
  0

... which standard style almost every single new patch of yours 
continues to violate in some trivial way.

We are not going to allow you to mess up kernel code that we 
maintain, so please address the review feedback you got from 
Peter and don't submit such trivially flawed patches next time 
around.

This is the fourth review round and counting, your stubborn 
idiocy continues to waste reviewer and maintainer time.

> Anyways I'm changing it but under protest.

Be careful with holding back your breath for too long, it can do 
permanent damage.

Thanks,

	Ingo
