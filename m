Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1C1Q5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:57:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:52445 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab1C1Q5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:57:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,256,1299484800"; 
   d="scan'208";a="619971564"
From: Andi Kleen <andi@firstfloor.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH]mmap: add alignment for some variables
References: <1301277536.3981.27.camel@sli10-conroe>
Date: Mon, 28 Mar 2011 09:55:47 -0700
In-Reply-To: <1301277536.3981.27.camel@sli10-conroe> (Shaohua Li's message of
	"Mon, 28 Mar 2011 09:58:56 +0800")
Message-ID: <m2oc4v18x8.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li <shaohua.li@intel.com> writes:

> Make some variables have correct alignment.

Nit: __read_mostly doesn't change alignment, just the section.
Please fix the description. Other than that it looks good.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
