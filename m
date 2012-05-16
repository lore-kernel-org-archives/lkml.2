Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab2EPPOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:14:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35688 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754599Ab2EPPOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:14:25 -0400
Message-ID: <1337181264.26509.12.camel@joe2Laptop>
Subject: Re: [PATCH v3 3/7] backlight: cr_bllcd: use pr_err/info instead of
 printk
From: Joe Perches <joe@perches.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Date: Wed, 16 May 2012 08:14:24 -0700
In-Reply-To: <003601cd333b$43094360$c91bca20$%han@samsung.com>
References: <003601cd333b$43094360$c91bca20$%han@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 17:09 +0900, Jingoo Han wrote:
> This patch uses pr_err/info instead of printk to allow dynamic debugging.

Hi again.

pr_debug, dev_dbg and netdev_dbg are the only things
that can use dynamic debugging.

All the other levels are just normal logging mechanisms.

