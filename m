Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab2JZNLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 09:11:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:42826 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab2JZNK6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 09:10:58 -0400
Message-ID: <1351257008.16863.63.camel@twins>
Subject: Re: [PATCH 2/2] numa, mm: consolidate error path in
 do_huge_pmd_numa_page()
From: Peter Zijlstra <peterz@infradead.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: linux-mm@kvack.org, Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Date: Fri, 26 Oct 2012 15:10:08 +0200
In-Reply-To: <1351256077-1594-2-git-send-email-kirill.shutemov@linux.intel.com>
References: <1351256077-1594-1-git-send-email-kirill.shutemov@linux.intel.com>
	 <1351256077-1594-2-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 15:54 +0300, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> Let's move all error path code to the end if the function. It makes code
> more straight-forward.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  mm/huge_memory.c |   44 ++++++++++++++++++++------------------------
>  1 file changed, 20 insertions(+), 24 deletions(-)

and smaller! Thanks!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
