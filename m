Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab2JARdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 13:33:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:17754 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab2JARdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 13:33:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,517,1344236400"; 
   d="scan'208";a="229170770"
Message-ID: <5069D3D8.9070805@linux.intel.com>
Date: Mon, 01 Oct 2012 10:33:12 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/3] Virtual huge zero page
References: <1348875441-19561-1-git-send-email-kirill.shutemov@linux.intel.com> <20120929134811.GC26989@redhat.com> <5069B804.6040902@linux.intel.com> <20121001163118.GC18051@redhat.com> <5069CCF9.7040309@linux.intel.com> <20121001172624.GD18051@redhat.com>
In-Reply-To: <20121001172624.GD18051@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 10:26 AM, Andrea Arcangeli wrote:
> 
>> It is well known that microbenchmarks can be horribly misleading.  What
>> led to Kirill investigating huge zero page in the first place was the
>> fact that some applications/macrobenchmarks benefit, and I think those
>> are the right thing to look at.
> 
> The whole point of the two microbenchmarks was to measure the worst
> cases for both scenarios and I think that was useful. Real life using
> zero pages are going to be somewhere in that range.
> 

... and I think it would be worthwhile to know which effect dominates
(or neither, in which case it doesn't matter).

Overall, I'm okay with either as long as we don't lock down 2 MB when
there isn't a huge zero page in use.

	-hpa

