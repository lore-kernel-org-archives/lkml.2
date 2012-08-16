Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030310Ab2HPTmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:42:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757634Ab2HPTmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:42:07 -0400
Date: Thu, 16 Aug 2012 21:42:01 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH, RFC 6/9] thp: add address parameter to
 split_huge_page_pmd()
Message-ID: <20120816194201.GQ11188@redhat.com>
References: <1344503300-9507-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1344503300-9507-7-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344503300-9507-7-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 12:08:17PM +0300, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> It's required to implement huge zero pmd splitting.
> 

This isn't bisectable with the next one, it'd fail on wfg 0-DAY kernel
build testing backend, however this is clearly to separate this patch
from the next, to keep the size small so I don't mind.
