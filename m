Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab1BOCaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 21:30:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58552 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab1BOCaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 21:30:10 -0500
Date: Tue, 15 Feb 2011 03:29:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        shaohui.zheng@intel.com, rientjes@google.com, hpa@linux.intel.com
Subject: Re: [PATCH UPDATED 03/26] x86, NUMA: Drop @start/last_pfn from
 initmem_init() initmem_init()
Message-ID: <20110215022956.GE31134@elte.hu>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
 <1297530663-26234-4-git-send-email-tj@kernel.org>
 <20110214135052.GJ18742@htj.dyndns.org>
 <20110214142011.GB27076@elte.hu>
 <20110214145802.GO18742@htj.dyndns.org>
 <4D597C87.8040404@kernel.org>
 <20110214193114.GD18742@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214193114.GD18742@htj.dyndns.org>
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

> On Mon, Feb 14, 2011 at 11:03:35AM -0800, Yinghai Lu wrote:
> > initmem_init() extensively accesses and modifies global data
> > structures and the parameters aren't even followed depending on which
> > path is being used.  Drop @start/last_pfn and let it deal with
> > @max_pfn directly.  This is in preparation for further NUMA init
> > cleanups.
> > 
> > -v2: x86-32 initmem_init() weren't updated breaking 32bit builds.  Fixed.
> >      Found by Yinghai
> 
> Alright, updated accordingly in the git tree.

Yeah, that kind of tag is fine too, or:

 Build-bug-in-v1-found-by: ...

:-)

Thanks,

	Ingo
