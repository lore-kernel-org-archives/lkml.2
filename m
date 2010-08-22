Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab0HVP3t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 11:29:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab0HVP3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 11:29:47 -0400
Message-ID: <4C714263.8060102@redhat.com>
Date: Sun, 22 Aug 2010 18:29:39 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Tim Pepper <lnxninja@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/4 v2] kvm: rework KVM mmu_shrink() code
References: <20100820011054.GA11297@tpepper-t61p.dolavim.us>
In-Reply-To: <20100820011054.GA11297@tpepper-t61p.dolavim.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/20/2010 04:10 AM, Tim Pepper wrote:
> The following series is the four patches Dave Hansen had queued for test
> as mentioned last week in the thread:
>    "[PATCH] kvm: make mmu_shrink() fit shrinker's requirement"
> Last week just before leaving for vacation Dave had noted in that thread
> that these four were ready to merge based on our perf team's testing
> finally having wrapped up.  But it turns out he hadn't actually posted
> them after refactoring in response to comments back in June...
>
> I'm covering for him in his absence and had previously reviewed this set.
> This version contains fixes in response to the comments in June.  The
> patches are pulled straight from Dave's development tree, as tested, with
> a minor build/merge change to patch #3 which was otherwise inadvertantly
> re-introducing an (unused) variable that Avi more recently had removed.
>
> Compared to the previous version from June:
> - patch #3 addresses Marcelo's comment about a double deaccounting
>    of kvm->arch.n_used_mmu_pages
> - patch #4 includes protection of the used mmu page counts in response to
>    Avi's comments
>
> Avi: if Dave's use of a per cpu counter in the refactored patch #4 is
> acceptable to you, then the series is for merging.
>

Applied, thanks for taking care of this.

-- 
error compiling committee.c: too many arguments to function

