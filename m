Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab2JGWVk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 18:21:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:20038 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab2JGWVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 18:21:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,549,1344236400"; 
   d="scan'208";a="222819626"
From: Andi Kleen <andi@firstfloor.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        mmarek@suse.cz, sam@ravnborg.org, rientjes@google.com
Subject: Re: [PATCH v2] Makefile: Add option to disable gcc automatic inlining
References: <1349637532-27466-1-git-send-email-elezegarcia@gmail.com>
Date: Sun, 07 Oct 2012 15:21:38 -0700
In-Reply-To: <1349637532-27466-1-git-send-email-elezegarcia@gmail.com>
	(Ezequiel Garcia's message of "Sun, 7 Oct 2012 16:18:52 -0300")
Message-ID: <m2haq5vs7h.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ezequiel Garcia <elezegarcia@gmail.com> writes:

> The new option is CONFIG_CC_DISABLE_AUTO_INLINE and it's
> located at:
>   * Kernel hacking
>     * Disable gcc automatic inlining

You don't state anywhere why you want that?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
