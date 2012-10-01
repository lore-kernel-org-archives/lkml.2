Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab2JARhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 13:37:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:28285 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab2JARha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 13:37:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,517,1344236400"; 
   d="scan'208";a="200289002"
Message-ID: <5069D4D3.1040003@linux.intel.com>
Date: Mon, 01 Oct 2012 10:37:23 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/3] Virtual huge zero page
References: <1348875441-19561-1-git-send-email-kirill.shutemov@linux.intel.com> <20120929134811.GC26989@redhat.com> <5069B804.6040902@linux.intel.com> <20121001163118.GC18051@redhat.com> <5069CCF9.7040309@linux.intel.com> <20121001172624.GD18051@redhat.com> <5069D3D8.9070805@linux.intel.com> <20121001173604.GC20915@shutemov.name>
In-Reply-To: <20121001173604.GC20915@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 10:36 AM, Kirill A. Shutemov wrote:
> On Mon, Oct 01, 2012 at 10:33:12AM -0700, H. Peter Anvin wrote:
>> Overall, I'm okay with either as long as we don't lock down 2 MB when
>> there isn't a huge zero page in use.
> 
> Is shinker-reclaimable huge zero page okay for you?
> 

Yes, I'm fine with that.  However, I'm curious about the relative
benefit versus virtual hzp from a performance perspective, on an
application where hzp actually matters.

One can otherwise argue that if hzp doesn't matter for except in a small
number of cases that we shouldn't use it at all.

	-hpa


