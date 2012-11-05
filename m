Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614Ab2KEPrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:47:48 -0500
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:58369 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab2KEPrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:47:46 -0500
Date: Mon, 5 Nov 2012 19:47:45 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] w1-gpio: Simplify & get rid of defines
Message-ID: <20121105154745.GB12922@ioremap.net>
References: <1351699064-4619-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351699064-4619-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Oct 31, 2012 at 05:57:44PM +0200, Pantelis Antoniou (panto@antoniou-consulting.com) wrote:
> There's no reason to have the OF defines; it complicates the driver.
> There's also no need for the funky platform_driver_probe.
> 
> Add a few warnings in case there's a failure; helps us find out
> what went wrong.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>

Looks good to me, but I'm hardly an expert in omap platform.
Feel free to add my ack, but please submit this patch through
appropriate tree.
Thank you.

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
