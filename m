Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab2HIP0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:26:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:47545 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756579Ab2HIP0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:26:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,740,1336374000"; 
   d="scan'208";a="205542693"
Date: Thu, 9 Aug 2012 08:26:20 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] x86: Add clear_page_nocache
Message-ID: <20120809152620.GH2644@tassilo.jf.intel.com>
References: <1344524583-1096-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1344524583-1096-5-git-send-email-kirill.shutemov@linux.intel.com>
 <5023F1BC0200007800093EF0@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5023F1BC0200007800093EF0@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> While on 64-bit this is fine, I fail to see how you avoid using the
> SSE2 instruction on non-SSE2 systems.

You're right, this needs a fallback path for 32bit non sse
(and fixing the ABI)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
