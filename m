Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148Ab0EDSQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:16:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:9627 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759678Ab0EDSQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:16:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,328,1270450800"; 
   d="scan'208";a="564069138"
Subject: Re: [PATCH 1/2] x86: eliminate TS_XSAVE
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
       "Cui, Dexuan" <dexuan.cui@intel.com>,
       Sheng Yang <sheng@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
In-Reply-To: <4BDFCF9F.3030600@redhat.com>
References: <1272812038-32484-1-git-send-email-avi@redhat.com>
	 <1272812038-32484-2-git-send-email-avi@redhat.com>
	 <u2p73c1f2161005021038gce35c1bbpca6ec119d24e646e@mail.gmail.com>
	 <4BDDBA18.3080909@redhat.com> <4BDF4407.8000503@zytor.com>
	 <4BDFCF9F.3030600@redhat.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 04 May 2010 11:15:27 -0700
Message-Id: <1272996927.2833.13.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 00:41 -0700, Avi Kivity wrote:
> On 05/04/2010 12:45 AM, H. Peter Anvin wrote:
> >
> >> I was trying to avoid a performance regression relative to the current
> >> code, as it appears that some care was taken to avoid the memory reference.
> >>
> >> I agree that it's probably negligible compared to the save/restore
> >> code.  If the x86 maintainers agree as well, I'll replace it with
> >> cpu_has_xsave.
> >>
> >>      
> > I asked Suresh to comment on this, since he wrote the original code.  He
> > did confirm that the intent was to avoid a global memory reference.
> >
> >    
> 
> Ok, so you're happy with the patch as is?

As use_xsave() is in the hot context switch path, I would like to go
with Avi's proposal.

thanks,
suresh

