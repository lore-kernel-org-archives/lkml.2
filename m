Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1FSVSk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 17:18:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:52100 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297Ab1FSVSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 17:18:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,390,1304319600"; 
   d="scan'208";a="16928037"
From: Andi Kleen <andi@firstfloor.org>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/19] OpenRISC: Scheduling/Process management
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
	<1308483825-6023-13-git-send-email-jonas@southpole.se>
Date: Sun, 19 Jun 2011 14:17:10 -0700
In-Reply-To: <1308483825-6023-13-git-send-email-jonas@southpole.se> (Jonas
	Bonn's message of "Sun, 19 Jun 2011 13:43:38 +0200")
Message-ID: <m2fwn5frmx.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonas Bonn <jonas@southpole.se> writes:

> + * normally, the stack is found by doing something like p + THREAD_SIZE
> + * in or32, a page is 8192 bytes, which seems like a sane size
> + */
> +
> +#define THREAD_SIZE       PAGE_SIZE
> +#define THREAD_SIZE_ORDER 1

The ORDER == 1 and 8k you would get a 16k stack per thread,
which may be excessive?

> +#if 0
> +
> +/*
> + * The hlt_counter, disable_hlt and enable_hlt is just here as a hook
> if
You definitely don't need that.


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
