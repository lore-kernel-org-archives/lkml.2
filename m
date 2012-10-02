Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab2JBPht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:37:49 -0400
Received: from shutemov.name ([176.9.204.213]:59675 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab2JBPhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:37:48 -0400
Date: Tue, 2 Oct 2012 18:38:23 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/10] thp: do_huge_pmd_wp_page(): handle huge zero
 page
Message-ID: <20121002153823.GA27771@shutemov.name>
References: <1349191172-28855-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1349191172-28855-5-git-send-email-kirill.shutemov@linux.intel.com>
 <506B09DF.7010209@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <506B09DF.7010209@inria.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 05:35:59PM +0200, Brice Goglin wrote:
> Le 02/10/2012 17:19, Kirill A. Shutemov a écrit :
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >
> > On right access to huge zero page we alloc a new page and clear it.
> >
> 
> s/right/write/ ?

Oops... thanks.

-- 
 Kirill A. Shutemov
