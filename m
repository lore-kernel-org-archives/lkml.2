Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab1HSXfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 19:35:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:5079 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab1HSXfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 19:35:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,253,1312182000"; 
   d="scan'208";a="41895985"
From: Andi Kleen <andi@firstfloor.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]arch:x86:kernel:cpu:mcheck:mce.c Fix comment, to sound more properly.
References: <1313774220-8902-1-git-send-email-justinmattock@gmail.com>
Date: Fri, 19 Aug 2011 16:35:32 -0700
In-Reply-To: <1313774220-8902-1-git-send-email-justinmattock@gmail.com>
	(Justin P. Mattock's message of "Fri, 19 Aug 2011 10:17:00 -0700")
Message-ID: <m2y5ypgekb.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Justin P. Mattock" <justinmattock@gmail.com> writes:
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -753,7 +753,7 @@ static int mce_start(int *no_way_out)
>  	} else {
>  		/*
>  		 * Subject: Now start the scanning loop one by one in
> -		 * the original callin order.
> +		 * the original calling order.


The change is wrong. It means really callin, not calling.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
