Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1K3UvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 15:51:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1K3UvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 15:51:13 -0500
Date: Wed, 30 Nov 2011 12:51:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Richard Purdie <rpurdie@rpsys.net>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] backlight: convert drivers/video/backlight/* to use
 module_platform_driver()
Message-Id: <20111130125111.f535453a.akpm@linux-foundation.org>
In-Reply-To: <1322273963.10633.1.camel@phoenix>
References: <1322273963.10633.1.camel@phoenix>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Nov 2011 10:19:23 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> This patch converts the drivers in drivers/video/backlight/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
>
>  drivers/video/backlight/adx_bl.c             |   13 +------------

fyi, I dropped the adx_bl.c part due to the pending "backlight: remove
ADX backlight device support" which remvoes that file.


