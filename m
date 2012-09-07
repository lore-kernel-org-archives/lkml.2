Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab2IGT31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:29:27 -0400
Received: from bitmer.com ([213.157.87.50]:46225 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab2IGT3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:29:25 -0400
Date: Fri, 7 Sep 2012 22:29:23 +0300
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-watchdog@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: omap_wdt: convert to new watchdog core
Message-ID: <20120907192923.GA16586@bitmer.com>
References: <1346769684-25543-1-git-send-email-aaro.koskinen@iki.fi>
 <20120907133107.GA14585@bitmer.com>
 <20120907155143.GA10099@harshnoise.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907155143.GA10099@harshnoise.musicnaut.iki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 06:51:43PM +0300, Aaro Koskinen wrote:
 
> Thanks for the report! I'll look into this and test with other
> Nokia boards. I tested the patch only with N800 and v3.6-rc4
> (4cbe5a555fa58a79b6ecbb6c531b8bab0650778d) and did not see any issues
> with normal use cases (boot, watchdog open, feeding, watchdog close).
>
I forgot to test on another hw but will try to do in coming days. Anyway I'm
happy to test your patch again if you spot something so you could cc also me
for retesting.

-- 
Jarkko
