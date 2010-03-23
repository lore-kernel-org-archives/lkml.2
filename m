Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0CWNtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:49:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34164 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab0CWNtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:49:06 -0400
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from host side
From: Andi Kleen <andi@firstfloor.org>
References: <1268717232.2813.36.camel@localhost>
	<1268969929.2813.184.camel@localhost> <20100319082122.GE12576@elte.hu>
	<20100319172903.GI13108@8bytes.org> <20100321184300.GB25922@elte.hu>
	<20100322101451.GK13108@8bytes.org> <20100322105927.GB3483@elte.hu>
	<20100322114744.GC1940@8bytes.org>
	<ye88w9j2n2y.fsf@camel23.daimi.au.dk>
Date: Tue, 23 Mar 2010 14:49:01 +0100
In-Reply-To: <ye88w9j2n2y.fsf@camel23.daimi.au.dk> (Soeren Sandmann's message of "23 Mar 2010 14:18:29 +0100")
Message-ID: <878w9jdu7m.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sandmann <sandmann@daimi.au.dk> writes:
>
> To fix that problem, it seems like we need some way to have python
> export what is going on. Maybe the same mechanism could be used to
> both access what is going on in qemu and python.

oprofile already has an interface to let JITs export
information about the JITed code. C Python is not a JIT,
but presumably one of the python JITs could do it.

http://oprofile.sourceforge.net/doc/devel/index.html

I know it's not envogue anymore and you won't be a approved 
cool kid if you do, but you could just use oprofile? 

Ok presumably one would need to do a python interface for this
first. I believe it's currently only implemented for Java and
Mono. I presume it might work today with IronPython on Mono.

IMHO it doesn't make sense to invent another interface for this,
although I'm sure someone will propose just that.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
