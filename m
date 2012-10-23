Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab2JWNdC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:33:02 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59828 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291Ab2JWNdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:33:00 -0400
Date: Tue, 23 Oct 2012 15:33:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 04/34] perf, x86: Support the TSX intx/intx_cp qualifiers
Message-ID: <20121023133300.GZ16230@one.firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org> <1350602382-12771-5-git-send-email-andi@firstfloor.org> <1350994159.13456.9.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350994159.13456.9.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 02:09:19PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-10-18 at 16:19 -0700, Andi Kleen wrote:
> > @@ -826,7 +827,8 @@ static inline bool intel_pmu_needs_lbr_smpl(struct perf_event *event)
> >                 return true;
> >  
> >         /* implicit branch sampling to correct PEBS skid */
> > -       if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
> > +       if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1 &&
> > +           x86_pmu.intel_cap.pebs_format < 2)
> >                 return true;
> >  
> >         return false; 
> 
> This seems unrelated to TSX, I suppose it belongs in the previous patch?

Ok will move.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
