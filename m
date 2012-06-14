Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab2FNUuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:50:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:20706 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab2FNUt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:49:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="156502183"
Subject: Re: [RFC] x86, fpu: unify signal handling code paths for x86 and
 x86_64 kernels
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Date: Thu, 14 Jun 2012 13:49:56 -0700
In-Reply-To: <4FDA4E2E.7030503@zytor.com>
References: <1339545814.28766.148.camel@sbsiddha-desk.sc.intel.com>
	 <4FDA4E2E.7030503@zytor.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1339706997.3475.35.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 13:48 -0700, H. Peter Anvin wrote:
> On 06/12/2012 05:03 PM, Suresh Siddha wrote:
> > I can split the patch if needed. And I need to do little bit more
> > validation (already tested on 64-bit IVB  and 32-bit NHM) before
> > removing the 'RFC' tag.
> > 
> > I tried starting with the old version of Hans patch. But there were lot
> > more changes in this area since then and also his patch had few
> > user-visible compatibility issues.
> > 
> > Appended is the version that I came up with. Please review.
> > 
> 
> This patch doesn't apply to v3.5-rc2.
> 

Patch I sent was against -tip tree.

