Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924Ab0KRW1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:27:09 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49583 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab0KRW1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:27:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hFqcyGD6TEXzgCoAUopOUpFU98Zj5LQwWcv15HRG0VWoztM0V0goPT5VKYnJLZo0I/
         9bsvQIkdd1CblbpgElJbUOtMhetD3dCp5Qv0KGT/8ZcqxyxH2/PyeFHNrybyVedWf/hI
         j4XOi2usRsohwCTOSFf0h9lqARttSY9NBwnbM=
Date: Fri, 19 Nov 2010 01:27:02 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
        ying.huang@intel.com, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101118222702.GO6028@lenovo>
References: <20101112172755.GR4823@redhat.com> <20101116184325.GB4823@redhat.com> <4CE2E3C3.6060800@windriver.com> <20101118080516.GJ32621@elte.hu> <4CE52048.5080802@windriver.com> <1290086232.2109.1507.camel@laptop> <20101118193247.GF18100@redhat.com> <20101118215650.GL6028@lenovo> <20101118221554.GA31253@lenovo> <4CE5A7AE.8070703@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE5A7AE.8070703@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 04:24:46PM -0600, Jason Wessel wrote:
... 
> It is retested and confirmed to work on real HW.   This no longer works
> on qemu/kvm likely because the emulation is incorrect.
> 
> Thanks,
> Jason.
> 

ok, thanks a lot Jason!

  Cyrill
