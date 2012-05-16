Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966663Ab2EPI7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:59:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:40638 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966046Ab2EPI7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:59:00 -0400
Message-ID: <1337158712.27694.134.camel@twins>
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Nick Piggin <npiggin@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        borislav.petkov@amd.com, yinghai@kernel.org, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk, jmorris@namei.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com,
        linux-arch@vger.kernel.org
Date: Wed, 16 May 2012 10:58:32 +0200
In-Reply-To: <4FB36B12.9000705@intel.com>
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>
	  <1337072138-8323-7-git-send-email-alex.shi@intel.com>
	  <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>
	  <4FB2590C.1050303@intel.com> <1337092577.27694.45.camel@twins>
	  <1337093840.27694.56.camel@twins> <4FB34D49.1060809@intel.com>
	  <1337155239.27694.131.camel@twins> <1337155464.27694.132.camel@twins>
	 <4FB36B12.9000705@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 16:53 +0800, Alex Shi wrote:
> 
> Sorry. Do you mean not every archs use 'include/asm-generic/tlb.h', so
> the assignment of tlb->start in tlb_gather_mmu make trouble?
> 
Yes exactly. I know you work for Intel, but surely its not forbidden by
contract to look outside of arch/x86/ ? I know!, look at arch/ia64/
that's still Intel.
