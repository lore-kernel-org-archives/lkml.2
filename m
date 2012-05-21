Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab2EUMUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 08:20:41 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:36207 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab2EUMUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 08:20:40 -0400
Date: Mon, 21 May 2012 14:20:34 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Subject: Re: [PATCH 1/3] backlight: atmel-pwm-bl: use devm_ functions
Message-ID: <20120521122034.GA25411@samfundet.no>
References: <002b01cd3732$b3d4c290$1b7e47b0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002b01cd3732$b3d4c290$1b7e47b0$%han@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 21 May 2012 18:18:36 +0900 or thereabout, Jingoo Han wrote:
> The devm_ functions allocate memory that is released when a driver
> detaches. This patch uses devm_kzalloc of these functions.

Looks good, thanks for the update.

> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
