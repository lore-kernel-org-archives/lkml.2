Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab0IAXaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 19:30:30 -0400
Received: from void.printf.net ([89.145.121.20]:41501 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab0IAXa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 19:30:29 -0400
Date: Thu, 2 Sep 2010 00:30:27 +0100
From: Chris Ball <cjb@laptop.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCH 0/3] mmc_test: show test results via sysfs
Message-ID: <20100901233027.GA5430@void.printf.net>
References: <cover.1283276161.git.ext-andriy.shevchenko@nokia.com> <20100901214644.GA4436@void.printf.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100901214644.GA4436@void.printf.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 10:46:44PM +0100, Chris Ball wrote:
> Unrelated to this patch, I'm hitting:
> 
>   drivers/mmc/core/core.c:174:
>     BUG_ON(mrq->data->blocks * mrq->data->blksz > host->max_req_size);

Ah, I see this was discussed on linux-mmc@, and Adrian's going to come
up with a patch for it.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
