Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab0KVKr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 05:47:26 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42998 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab0KVKrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 05:47:24 -0500
Date: Mon, 22 Nov 2010 11:47:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: castet.matthieu@free.fr
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>, Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: -tip tree resume fail, bisect to 5bd5a45(x86: Add NX
 protection for kernel data)
Message-ID: <20101122104722.GB21836@basil.fritz.box>
References: <1290410581.2405.24.camel@minggr.sh.intel.com>
 <20101122080710.GA1510@elte.hu>
 <20101122092003.GA21836@basil.fritz.box>
 <1290421744.4cea45f0614d4@imp.free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290421744.4cea45f0614d4@imp.free.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> But X64_ALIGN_DEBUG_RODATA_BEGIN is aligned on 2M, so it shouldn't change
> nothing on x64 ?

Yes sorry for the confusion. That's unrelated to your patch and already 
happened earlier.  I just noticed it while looking at the page table dumps 
in the report.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
