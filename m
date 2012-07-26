Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab2GZAcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 20:32:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:9634 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab2GZAcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 20:32:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126952351"
Message-ID: <5010900E.2030008@linux.intel.com>
Date: Wed, 25 Jul 2012 17:32:14 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "Theodore T'so" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, w@1wt.edu, ewust@umich.edu,
        zakir@umich.edu, greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@vger.kernel.org, DJ Johnston <dj.johnston@intel.com>
Subject: Re: [PATCH] random: mix in architectural randomness in extract_buf()
References: <20120725151000.GA30996@thunk.org>  <1343237822-7789-1-git-send-email-hpa@zytor.com> <1343260256.5132.172.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1343260256.5132.172.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 04:50 PM, Ben Hutchings wrote:
> On Wed, 2012-07-25 at 10:37 -0700, H. Peter Anvin wrote:
>> From: "H. Peter Anvin" <hpa@linux.intel.com>
>>
>> RDRAND is so much faster than the Linux pool system that we can
>> always just mix in architectural randomness.
> [...]
>> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>> Acked-by: Ingo Molnar <mingo@kernel.org>
>> Cc: DJ Johnston <dj.johnston@intel.com>
> [...]
> 
> This is not the correct way to submit patches for stable; see
> Documentation/stable_kernel_rules.txt
> 

The patch is intended to fix the security regression that would be
caused if Ted's random.git patches are accepted in -stable, which isn't
clear to me if they will be or not, so I added the Cc: to keep it from
getting lost.

	-hpa
