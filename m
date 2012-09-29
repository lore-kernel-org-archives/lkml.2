Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab2I2OaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 10:30:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:57289 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab2I2OaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 10:30:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,507,1344236400"; 
   d="scan'208";a="199695574"
Date: Sat, 29 Sep 2012 07:30:06 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/3] Virtual huge zero page
Message-ID: <20120929143006.GC4110@tassilo.jf.intel.com>
References: <1348875441-19561-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20120929134811.GC26989@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120929134811.GC26989@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 03:48:11PM +0200, Andrea Arcangeli wrote:
> On Sat, Sep 29, 2012 at 02:37:18AM +0300, Kirill A. Shutemov wrote:
> > Cons:
> >  - increases TLB pressure;
> 
> I generally don't like using 4k tlb entries ever. This only has the

>From theory I would also prefer the 2MB huge page.

But some numbers comparing between the two alternatives are definitely
interesting.  Numbers are often better than theory.

> There would be a small cache benefit here... but even then some first
> level caches are virtually indexed IIRC (always physically tagged to

Modern x86 doesn't have virtually indexed caches.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
