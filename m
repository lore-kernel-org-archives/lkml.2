Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab1BNOVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:21:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32944 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab1BNOVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:21:14 -0500
Date: Mon, 14 Feb 2011 15:21:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, hpa@linux.intel.com
Subject: Re: [PATCH UPDATED 06/26] x86, NUMA: Move *_numa_init() invocations
 into initmem_init()
Message-ID: <20110214142100.GC27076@elte.hu>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
 <1297530663-26234-7-git-send-email-tj@kernel.org>
 <20110214135152.GK18742@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214135152.GK18742@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> There's no reason for these to live in setup_arch().  Move them inside
> initmem_init().
> 
> * x86-32 initmem_init() weren't updated breaking 32bit builds.  Fixed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Brian Gerst <brgerst@gmail.com>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: Shaohui Zheng <shaohui.zheng@intel.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Ankita Garg <ankita@in.ibm.com>
> ---
> Updated to convert 32bit initmem_init() too.  Both parameters weren't
> being used in 32bit versions.  git tree updated accordingly.

This commit is missing a:

  Reported-by: Ankita Garg <ankita@in.ibm.com>

tag.

Thanks,

	Ingo
