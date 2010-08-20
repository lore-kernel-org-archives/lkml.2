Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab0HTWPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 18:15:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:54769 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab0HTWPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 18:15:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,242,1280732400"; 
   d="scan'208";a="649780970"
Date: Sat, 21 Aug 2010 00:15:49 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MFD: move AB3100 to __devinit
Message-ID: <20100820221549.GN3650@sortiz-mobl>
References: <1282292816-4535-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282292816-4535-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Aug 20, 2010 at 10:26:56AM +0200, Linus Walleij wrote:
> Since there is no discardable probe() function in the I2C device
> framework, let's just tag it __devinit and take the footprint hit
> rather than seeing the compilation warnings every day.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
