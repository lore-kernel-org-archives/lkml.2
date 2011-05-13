Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab1EMSXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:23:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:55555 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab1EMSXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:23:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,365,1301900400"; 
   d="scan'208";a="642408723"
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, x86@kernel.org,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: Possible sandybridge livelock issue
References: <1305303156.2611.51.camel@mulgrave.site>
	<m262pezhfe.fsf@firstfloor.org>
	<alpine.DEB.2.00.1105131207020.24193@router.home>
Date: Fri, 13 May 2011 11:23:14 -0700
In-Reply-To: <alpine.DEB.2.00.1105131207020.24193@router.home> (Christoph
	Lameter's message of "Fri, 13 May 2011 12:08:06 -0500 (CDT)")
Message-ID: <m21v02zch9.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux.com> writes:

> On Fri, 13 May 2011, Andi Kleen wrote:
>
>> Turbo mode just makes the CPU faster, but it should not change
>> the scheduler decisions.
>
> I also have similar issues with Sandybridge on Ubuntu 11.04 and kernels
> 2.6.38 as well as 2.6.39 (standard ubuntu kernel configs).

It still doesn't make a lot of sense to blame the CPU for this.
This is just not the level how CPU problems would likely appear.

Can you figure out better what the kswapd is doing?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
