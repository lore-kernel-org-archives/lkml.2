Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab2K2TC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:02:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:64419 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745Ab2K2TC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:02:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,186,1355126400"; 
   d="scan'208";a="255186737"
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: glommer@parallels.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [RFC, PATCH 00/19] Numa aware LRU lists and shrinkers
References: <1354058086-27937-1-git-send-email-david@fromorbit.com>
Date: Thu, 29 Nov 2012 11:02:24 -0800
In-Reply-To: <1354058086-27937-1-git-send-email-david@fromorbit.com> (Dave
	Chinner's message of "Wed, 28 Nov 2012 10:14:27 +1100")
Message-ID: <m24nk8grlr.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:
>
> Comments, thoughts and flames all welcome.

Doing the reclaim per CPU sounds like a big change in the VM balance. 
Doesn't this invalidate some zone reclaim mode settings?
How did you validate all this?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
