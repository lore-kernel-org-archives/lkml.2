Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab1ACQVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 11:21:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:53081 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab1ACQVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 11:21:52 -0500
Message-Id: <1bdc18$j527vf@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,267,1291622400"; 
   d="scan'208";a="642850812"
Date: Mon, 03 Jan 2011 16:21:09 +0000
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Loss of PAT-WC after resume on i5
Cc: linux-kernel@vger.kernel.org,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
In-Reply-To: <4D21F2C1.30500@zytor.com>
References: <849307$b076ne@azsmga001.ch.intel.com> <4D21F2C1.30500@zytor.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Jan 2011 08:01:05 -0800, "H. Peter Anvin" <hpa@zytor.com> wrote:
> Sounds like it.  It sounds based on your description that it's something
> more fundamental than just the state of the PAT MSR being lost, too,
> although perhaps that's the first thing to check...

Right, I should have mentioned that a rdmsr(MSR_ISA32_CR_PAT) showed no
change across a dysfunctional resume. And that
/sys/kernel/debug/x86/pat_memtype_list had the same contents (just the
first entries reversed upon resume).
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
