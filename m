Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab2JARfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 13:35:32 -0400
Received: from shutemov.name ([176.9.204.213]:59655 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab2JARfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 13:35:31 -0400
Date: Mon, 1 Oct 2012 20:36:04 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/3] Virtual huge zero page
Message-ID: <20121001173604.GC20915@shutemov.name>
References: <1348875441-19561-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20120929134811.GC26989@redhat.com>
 <5069B804.6040902@linux.intel.com>
 <20121001163118.GC18051@redhat.com>
 <5069CCF9.7040309@linux.intel.com>
 <20121001172624.GD18051@redhat.com>
 <5069D3D8.9070805@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5069D3D8.9070805@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 10:33:12AM -0700, H. Peter Anvin wrote:
> Overall, I'm okay with either as long as we don't lock down 2 MB when
> there isn't a huge zero page in use.

Is shinker-reclaimable huge zero page okay for you?

-- 
 Kirill A. Shutemov
