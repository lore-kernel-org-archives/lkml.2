Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab2FOBQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 21:16:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:38738 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab2FOBQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 21:16:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="156582539"
Subject: Re: [RFC] x86, fpu: unify signal handling code paths for x86 and
 x86_64 kernels
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        robert.richter@amd.com, andreas.herrmann3@amd.com
Date: Thu, 14 Jun 2012 18:16:44 -0700
In-Reply-To: <4FDA8C36.1020803@zytor.com>
References: <1339545814.28766.148.camel@sbsiddha-desk.sc.intel.com>
	   <20120614143727.GF7922@escobedo.osrc.amd.com>
	  <1339719035.3475.52.camel@sbsiddha-desk.sc.intel.com>
	  <4FDA7EDE.3070408@zytor.com>
	 <1339722435.3475.57.camel@sbsiddha-desk.sc.intel.com>
	 <4FDA8C36.1020803@zytor.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1339723004.3475.59.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 18:13 -0700, H. Peter Anvin wrote:
> On 06/14/2012 06:07 PM, Suresh Siddha wrote:
> > Ok. Fix for the existing mainline code appended. Can you queue this
> > separately?
> 
> Your unification patch still needs this too, though, right?
> 

Yes, that will be new code. Not for 3.5 though. So will send it
separately, when I send the non-RFC version of the signal unification
patches.

thanks,
suresh

