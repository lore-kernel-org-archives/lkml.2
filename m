Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab2HFLQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 07:16:26 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:40154 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab2HFLQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 07:16:25 -0400
X-Greylist: delayed 1627 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2012 07:16:25 EDT
Date: Mon, 6 Aug 2012 12:49:12 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Subject: Re: [PATCH 1/3] backlight: atmel-pwm-bl: remove goto err_free_mem
Message-ID: <20120806104912.GA22900@samfundet.no>
References: <003e01cd73b6$5a2ec8b0$0e8c5a10$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003e01cd73b6$5a2ec8b0$0e8c5a10$%han@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 06 Aug 2012 18:32:09 +0900 or thereabout, Jingoo Han wrote:
> This patch removes goto err_free_mem, which makes code a bit smaller.
> 
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

<snipp diff>

-- 
Hans-Christian Egtvedt
