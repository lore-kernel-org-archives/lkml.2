Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab0HXR2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 13:28:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54068 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab0HXR2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 13:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TVpzFI7xV7kFfvoZCitYEYBkVTRw2Z84iOT3CvAnaUR0K+CZFCx6IsGvYsAmDhdwPx
         r9bSEq6rtsurPrLZQvx2CMfwe96+cX+JmJSRKtH8hy0yK5fyP1OXFlPmLA6rSMNoa28G
         fNnHWbCn4zHaPiqhwX97RwrYoIXsvSWDXX/Gs=
Date: Tue, 24 Aug 2010 21:28:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100824172806.GF5723@lenovo>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com> <20100820152510.GA4167@elte.hu> <20100823085339.GA26713@elte.hu> <20100824171504.GI26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100824171504.GI26154@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 07:15:05PM +0200, Robert Richter wrote:
> On 23.08.10 04:53:39, Ingo Molnar wrote:
> > Ok, to not hold up the perf/urgent flow i zapped these two commits for 
> > the time being:
> > 
> >  4a31beb: perf, x86: Fix handle_irq return values
> >  8e3e42b: perf, x86: Try to handle unknown nmis with an enabled PMU
> 
> Ingo, are those commits in some branch to fetch them for testing? I
> did not find them in tip/master.
> 
> Thanks,
> 
> -Robert
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center
>

Robert, they should be in -tip tree, I have

| commit 4a31bebe71ab2e4f6ecd6e5f9f2ac9f0ff38ff76
| Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
| Date:   Thu Aug 19 16:28:00 2010 +0200
|
|    perf, x86: Fix handle_irq return values
    
	-- Cyrill
