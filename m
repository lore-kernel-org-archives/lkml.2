Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab1BOJLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:11:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47485 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab1BOJLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:11:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O7b1r6MhSSg4A9wgYy9trnn2qryNmN0L9eF6gSuQGPu465gwWSLVIejDBw8J4raijt
         Hs5sauoF8gpqs61H1U8BSrp/f5Z7xN7CnWcMYrnLQPnJLlyg3aMNv93zPMemRhyEaG5N
         CFWZD9WQF2xpZc4FORCSVg6kR+pVoH5wNZDng=
Date: Tue, 15 Feb 2011 10:11:03 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 15/26] x86-64, NUMA: Unify the rest of memblk
 registration
Message-ID: <20110215091103.GC3160@htj.dyndns.org>
References: <20110214113221.GG18742@htj.dyndns.org>
 <AANLkTin0C2AhtHm6K0av2N4pQxLvK_Fc+4w12Qg_QRkZ@mail.gmail.com>
 <20110214161249.GV18742@htj.dyndns.org>
 <AANLkTim8vaDDbdAK3Q2+LNOcYsH+VbpG+XUdD6wggNfL@mail.gmail.com>
 <20110214162247.GX18742@htj.dyndns.org>
 <AANLkTi=1xKqmedFqHPgDR32OrmNXg-T34NFo8qEnymfp@mail.gmail.com>
 <20110214182718.GB18742@htj.dyndns.org>
 <4D597D56.5060408@kernel.org>
 <20110214193050.GC18742@htj.dyndns.org>
 <4D5983EA.4020103@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5983EA.4020103@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 11:35:06AM -0800, Yinghai Lu wrote:
> On 02/14/2011 11:30 AM, Tejun Heo wrote:
> > On Mon, Feb 14, 2011 at 11:07:02AM -0800, Yinghai Lu wrote:
> >> Never mind. will send out patch after your patches get merged into tip.
> > 
> > Alright, fair enough.
> > 
> >> BTW, you may need to rebase your on top of tip/master.
> > 
> > Yeah, I saw a new patch going into the numa branch, but shouldn't this
> > and the next series based on x86/numa?  That was how it was done with
> > the previous series.
> 
> there is patch about init_memory_mapping_high() in tip/x86/bootmem.
> it will put pgtable on local nodes.

Ingo, hpa, how do you guys want to handle this?  Maybe you can cherry
pick or pull the branch into x86/numa?

Thanks.

-- 
tejun
