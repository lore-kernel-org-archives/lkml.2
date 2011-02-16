Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836Ab1BPJbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 04:31:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57969 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab1BPJbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 04:31:37 -0500
Date: Wed, 16 Feb 2011 10:31:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        shaohui.zheng@intel.com, rientjes@google.com, hpa@linux.intel.com
Subject: Re: [PATCH 15/26] x86-64, NUMA: Unify the rest of memblk registration
Message-ID: <20110216093124.GA20770@elte.hu>
References: <20110214182718.GB18742@htj.dyndns.org>
 <4D597D56.5060408@kernel.org>
 <20110214193050.GC18742@htj.dyndns.org>
 <4D5983EA.4020103@kernel.org>
 <20110215091103.GC3160@htj.dyndns.org>
 <20110215094327.GA1387@elte.hu>
 <20110215164920.GR3160@htj.dyndns.org>
 <20110216084105.GG16529@elte.hu>
 <20110216084852.GA17732@elte.hu>
 <20110216090123.GE19830@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216090123.GE19830@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Wed, Feb 16, 2011 at 09:48:52AM +0100, Ingo Molnar wrote:
> > I consolidated all these topics into the generic x86/mm tree which you could use as 
> > a base.
> > 
> > I did not recognize the level of conflicts until i tried to pull your tree. You can 
> > generally test such interactions with other bits of the x86 tree by test-merging 
> > your pending work to tip:master.
> 
> Alright, I'll just rebase it on top of x86/mm and send a proper pull
> request.

The tip of x86/mm is:

  275a88d3cf0e: Merge branch 'x86/amd-nb' into x86/mm

Thanks,

	Ingo
