Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab1BPOSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 09:18:10 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43236 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638Ab1BPOSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 09:18:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dqocpbMoAXLeQHoEfPUtGahAOmRxoxDjWbo1a80Nqv8KHPvbMknN87mF3jOnAN69Z6
         3QCq00pE1DFhw+fIkQwAL5+QZDibhzSAo5GwkC/3k7tf6wdR1DYZYrVMqlEYAkEJ6d5T
         u4cZnbM7jK4N77TAXgVvss3bAQ1m8Y5C70G/M=
Date: Wed, 16 Feb 2011 15:17:57 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, hpa@linux.intel.com, ankita@in.ibm.com
Subject: Re: [PATCHSET x86/numa] x86-64, NUMA: bring sanity to NUMA
 config/emulation
Message-ID: <20110216141757.GG19830@htj.dyndns.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
 <20110216125249.GA18113@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216125249.GA18113@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

On Wed, Feb 16, 2011 at 01:52:49PM +0100, Ingo Molnar wrote:
> allyes64config fails with:
> 
> arch/x86/mm/numa_64.c:1045: error: 'physnid' undeclared (first use in this function)
> arch/x86/mm/numa_64.c:1045: error: (Each undeclared identifier is reported only once
> arch/x86/mm/numa_64.c:1045: error: for each function it appears in.)

Dang, sorry about that.  Updated patch posted and git tree updated.
One patch in the emulation series is affected.  x86_64-numa-unify
branch remains the same.  x86_64-numa-emu-unify updated.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_64-numa-emu-unify

The new HEAD is 6e3019a9bf55000694b0d7058b39a1eebdf9877a.

Thanks.

-- 
tejun
