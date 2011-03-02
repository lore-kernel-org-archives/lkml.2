Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab1CBMCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 07:02:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:38517 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab1CBMCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 07:02:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,252,1297065600"; 
   d="scan'208";a="663006879"
Date: Wed, 2 Mar 2011 13:01:57 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] MFD: pm poweroff moved to ab8500-sysctrl
Message-ID: <20110302120156.GK16181@sortiz-mobl>
References: <1299063270-4096-1-git-send-email-mattias.wallin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299063270-4096-1-git-send-email-mattias.wallin@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mattias,

On Wed, Mar 02, 2011 at 11:54:30AM +0100, Mattias Wallin wrote:
> This patch moves the machine pm power off hook from the platform
> code to the ab8500-sysctrl driver.
A couple questions:
- Where is the aforementioned platform code ? In LinusW tree ?
- I suppose you're moving it in the sysctrl driver to prevent the same routine
to be spread over several platforms. If that's the case, please mention it in
the changelog.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
