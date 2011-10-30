Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159Ab1J3W6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 18:58:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:43407 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740Ab1J3W63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 18:58:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="69144901"
Date: Mon, 31 Oct 2011 00:02:18 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd/abx500: fix missing abx500 header file updates
Message-ID: <20111030230218.GK3897@sortiz-mobl>
References: <1319804135-2740-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319804135-2740-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Oct 28, 2011 at 02:15:35PM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> I missed to include a patch adding the new silicon revision define
> CUT3P3 and remove the retired CUT0 versions of AB8500. Also delete
> the reference to the retired AB3550 from the header.
Thanks. I had to apply it manually as the first chunk would not apply against
my for-next branch, but I pushed the actual fix now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
