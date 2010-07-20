Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab0GTUFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:05:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:55931 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab0GTUFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:05:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,234,1278313200"; 
   d="scan'208";a="640183543"
Subject: Re: [PATCH 00/10] x86, xsave: some code cleanups and reworks
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100720194606.GO26154@erda.amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
	 <20100720192717.GC6227@lenovo>  <20100720194606.GO26154@erda.amd.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 20 Jul 2010 13:05:11 -0700
Message-Id: <1279656311.2899.9.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-20 at 12:46 -0700, Robert Richter wrote:
> On 20.07.10 15:27:17, Cyrill Gorcunov wrote:
> > On Tue, Jul 20, 2010 at 08:50:47PM +0200, Robert Richter wrote:
> > >
> > > This patch series contains some cleanups and reworks I made during
> > > code review and feature implementation for upcoming cpus.
> > > 
> > > Most patches refactor the xsave initialization that is very dependent
> > > on fpu initialization. This series starts to decouple this a little
> > > bit as xsave not only supports fpu features. Also this is an attempt
> > > to ease the xsave interface by making some of the functions and
> > > variables static.
> > > 
> > > There is also one patch that removes boot_cpu_id variable, which is
> > > not really related to xsave. Maybe this should be applied to another
> > > branch.
> > > 
> > > The patches are relative to today's tip/x86/xsave branch.
> > > 
> > > (The patches are small for better review and rebasing.)
> > > 
> > > -Robert
> > > 
> > 
> > Hi Robert, I recall there was a thread related to boot_cpu_id and
> > cpu = 0. Unfortunately I can't find it neither in my mbox nor somewhere
> > in net at moment.
> 
> I found this patch:
> 
>  b3572e3 x86/voyager: fix compile breakage caused by dc1e35c6e95e8923cf1d3510438b63c600fee1e2
> 
> indicating that boot cpu id could be different than 0.
> 
> But either this is broken again, or the issue is gone in a different
> way.

Voyager code was removed from the tree since then.

thanks
suresh

