Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab2IGTV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:21:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:18732 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab2IGTV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:21:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,387,1344236400"; 
   d="scan'208";a="190163324"
Subject: Re: [PATCH 2/3] x86, fpu: enable eagerfpu by default for xsaveopt
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, andreas.herrmann3@amd.com,
        bp@amd64.org, robert.richter@amd.com, linux-kernel@vger.kernel.org
Date: Fri, 07 Sep 2012 12:20:56 -0700
In-Reply-To: <504A403F.10501@zytor.com>
References: <1347042703-11128-1-git-send-email-suresh.b.siddha@intel.com>
	 <1347042703-11128-2-git-send-email-suresh.b.siddha@intel.com>
	 <504A403F.10501@zytor.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1347045657.26695.64.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 11:43 -0700, H. Peter Anvin wrote:
> On 09/07/2012 11:31 AM, Suresh Siddha wrote:
> >
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index 6273099..b21bcbd 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -1835,7 +1835,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >   			enabling legacy floating-point and sse state.
> >
> >   	eagerfpu=	[X86]
> > -			on	enable eager fpu restore
> > +			on	enable eager fpu restore (default for xsaveopt)
> >   			off	disable eager fpu restore
> >
> 
> Should we make this a tristate (on, off, default/auto)?

Intention is to automatically enable it for xsaveopt with out any
explicit boot parameters (for the advantages I mentioned in the previous
changelogs).

thanks,
suresh


