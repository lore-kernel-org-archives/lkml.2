Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab2EIOp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:45:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:37407 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757939Ab2EIOpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:45:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="141891835"
Date: Wed, 9 May 2012 16:55:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH] mfd/stmpe: allow for const keyboard data
Message-ID: <20120509145523.GK1794@sortiz-mobl>
References: <1335184124-9105-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335184124-9105-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Apr 23, 2012 at 02:28:44PM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Since it's not like we will re-arrange the keys at run-time, it
> seems proper to allow the keymap data to be const. This solves
> a compilation warning in ux500.
> 
> Cc: Dmitry Torokhov <dtor@mail.ru>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  include/linux/mfd/stmpe.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
