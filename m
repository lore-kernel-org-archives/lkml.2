Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab1CNTuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:50:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:59707 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351Ab1CNTuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:50:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,317,1297065600"; 
   d="scan'208";a="720066594"
From: Andi Kleen <andi@firstfloor.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH tip:x86/mm 1/3] x86: A fast way to check capabilities of the current cpu
References: <20110312115010.GC2005@htj.dyndns.org>
Date: Mon, 14 Mar 2011 12:49:14 -0700
In-Reply-To: <20110312115010.GC2005@htj.dyndns.org> (Tejun Heo's message of
	"Sat, 12 Mar 2011 12:50:10 +0100")
Message-ID: <m2k4g1zdmt.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Add this_cpu_has() which determines if the current cpu has a certain
> ability using a segment prefix and a bit test operation.


Hmm: if the CPU capability is really tested in a performance critical
path, wouldn't it even be better to just use static_branch() now? 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
