Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1ITSoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:44:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:14925 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab1ITSog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:44:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,412,1312182000"; 
   d="scan'208";a="53694532"
From: Andi Kleen <andi@firstfloor.org>
To: Dean Nelson <dnelson@redhat.com>
Cc: linux-mm@kvack.org, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] HWPOISON: Convert pr_debug()s to pr_info()s
References: <20110920183254.3926.59134.email-sent-by-dnelson@localhost6.localdomain6>
Date: Tue, 20 Sep 2011 11:44:35 -0700
In-Reply-To: <20110920183254.3926.59134.email-sent-by-dnelson@localhost6.localdomain6>
	(Dean Nelson's message of "Tue, 20 Sep 2011 14:32:55 -0400")
Message-ID: <m27h53dpf0.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dean Nelson <dnelson@redhat.com> writes:

> Commit fb46e73520940bfc426152cfe5e4a9f1ae3f00b6 authored by Andi Kleen
> converted a number of pr_debug()s to pr_info()s.
>
> About the same time additional code with pr_debug()s was added by
> two other commits 8c6c2ecb44667f7204e9d2b89c4c1f42edc5a196 and
> d950b95882f3dc47e86f1496cd3f7fef540d6d6b. And these pr_debug()s
> failed to get converted to pr_info()s.
>
> This patch converts them as well. And does some minor related
> whitespace cleanup.
>
> Signed-off-by: Dean Nelson <dnelson@redhat.com>

Looks good. Andrew please merge.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
