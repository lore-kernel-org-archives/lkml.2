Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2KNXvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 18:51:22 -0500
Received: from mga03.intel.com ([143.182.124.21]:50684 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397Ab2KNXvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 18:51:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,252,1352102400"; 
   d="scan'208";a="217956608"
Message-ID: <50A42E77.8030200@linux.intel.com>
Date: Wed, 14 Nov 2012 15:51:19 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 00/11] Introduce huge zero page
References: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com> <20121114133342.cc7bcd6e.akpm@linux-foundation.org> <20121114232013.7ee42414@pyramind.ukuu.org.uk> <20121114153243.0f6d6bec.akpm@linux-foundation.org>
In-Reply-To: <20121114153243.0f6d6bec.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 03:32 PM, Andrew Morton wrote:
> 
> The current code does the latter, by freeing the page via a
> "slab"-shrinker callback.
> 
> But I do suspect that with the right combination of use/unuse and
> memory pressure, we could still get into the high-frequency scenario.
> 

There probably isn't any mechanism that doesn't end up with poor results
in some corner case... just like the vhzp variant.

	-hpa

