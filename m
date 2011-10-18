Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab1JRPsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:48:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:28720 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932896Ab1JRPsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:48:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,365,1315206000"; 
   d="scan'208";a="27778686"
From: Andi Kleen <andi@firstfloor.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] Reduce vm_stat cacheline contention in __vm_enough_memory
References: <20111013135032.7c2c54cd.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1110131602020.26553@router.home>
	<20111013142434.4d05cbdc.akpm@linux-foundation.org>
	<20111014122506.GB26737@sgi.com> <20111014135055.GA28592@sgi.com>
	<alpine.DEB.2.00.1110140856420.6411@router.home>
	<20111014141921.GC28592@sgi.com>
	<alpine.DEB.2.00.1110140932530.6411@router.home>
	<alpine.DEB.2.00.1110140958550.6411@router.home>
	<20111014161603.GA30561@sgi.com> <20111018134835.GA16222@sgi.com>
Date: Tue, 18 Oct 2011 08:48:44 -0700
In-Reply-To: <20111018134835.GA16222@sgi.com> (Dimitri Sivanich's message of
	"Tue, 18 Oct 2011 08:48:35 -0500")
Message-ID: <m2mxcyz4f7.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitri Sivanich <sivanich@sgi.com> writes:
>
> Would it make sense to have the ZVC delta be tuneable (via /proc/sys/vm?), keeping the
> same default behavior as what we currently have?

Tunable is bad. We don't really want a "hundreds of lines magic shell script to
make large systems perform". Please find a way to auto tune.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
