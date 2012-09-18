Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab2IRH3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:29:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:58635 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756862Ab2IRH3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:29:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,441,1344236400"; 
   d="scan'208";a="223430027"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] [RESEND] console: implement lockdep support for console_lock
In-Reply-To: <1347923013-4253-2-git-send-email-daniel.vetter@ffwll.ch>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1347923013-4253-1-git-send-email-daniel.vetter@ffwll.ch> <1347923013-4253-2-git-send-email-daniel.vetter@ffwll.ch>
User-Agent: Notmuch/0.13.2+113~gc6f17a0 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 18 Sep 2012 10:33:28 +0300
Message-ID: <87627b9453.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2012, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> +#ifdef CONFIG_LOCKDEP
> +struct lockdep_map console_lock_dep_map = {
> +	.name = "console_lock"
> +};
> +#endif

static?


BR,
Jani.
