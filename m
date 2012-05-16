Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030234Ab2EPLEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:04:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56392 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967293Ab2EPLEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:04:37 -0400
Message-ID: <1337166253.27694.136.camel@twins>
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <lkml.alex@gmail.com>
Cc: Alex Shi <alex.shi@intel.com>, Nick Piggin <npiggin@gmail.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, tj@kernel.org, oleg@redhat.com,
        axboe@kernel.dk, jmorris@namei.org, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com, linux-arch@vger.kernel.org
Date: Wed, 16 May 2012 13:04:13 +0200
In-Reply-To: <CAGjg+kGErUbt5JS7SLCGtUO_JKk0LtkpyM4JgFUsxHME53k=hQ@mail.gmail.com>
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>
	 <1337072138-8323-7-git-send-email-alex.shi@intel.com>
	 <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>
	 <4FB2590C.1050303@intel.com> <1337092577.27694.45.camel@twins>
	 <1337093840.27694.56.camel@twins> <4FB34D49.1060809@intel.com>
	 <1337155239.27694.131.camel@twins> <1337155464.27694.132.camel@twins>
	 <4FB36B12.9000705@intel.com> <1337158712.27694.134.camel@twins>
	 <CAGjg+kGErUbt5JS7SLCGtUO_JKk0LtkpyM4JgFUsxHME53k=hQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 18:58 +0800, Alex Shi wrote:
> If someone can unify the common fields of mmu_gather, and
> left private field for specific arch. it will be great and much
> helpful. 

I've send you a link to a patch-set that does exactly that twice now.

  http://marc.info/?l=linux-mm&m=129952019004146&w=2

There, 3rd time, now go read all 15 patches ;-)


Getting that merged is still on the todo list, I just got preempted by
other stuff :/




