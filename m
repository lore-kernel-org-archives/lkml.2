Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab0DVEgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 00:36:14 -0400
Received: from mail.perches.com ([173.55.12.10]:1679 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab0DVEgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 00:36:13 -0400
Subject: Re: [PATCH] Staging: Comedi: Drivers: Fix coding style issues in
 dt2801.c
From: Joe Perches <joe@perches.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Gustavo Silva <silvagustavosilva@gmail.com>, gregkh@suse.de,
       abbotti@mev.co.uk, devel@driverdev.osuosl.org,
       fmhess@users.sourceforge.net, linux-kernel@vger.kernel.org,
       silvagustavo@users.sourceforge.net
In-Reply-To: <20100422041338.GE24384@pengutronix.de>
References: <1271907971-8793-1-git-send-email-silvagustavo@users.sourceforge.net>
	 <1271908811.1730.613.camel@Joe-Laptop.home>
	 <20100422041338.GE24384@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 21:36:11 -0700
Message-ID: <1271910971.1730.637.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 06:13 +0200, Wolfram Sang wrote:
> What about dev_* in case there are more than one of those devices?

or netdev_<level>

> Also, KERN_INFO doesn't look right, KERN_WARN?

KERN_WARNING.  Maybe kernel.h should add:
#define pr_warn pr_warning 

so there would be symmetry between levels of
pr_<level>, dev_<level>, netdev_<level>, and netif_<level>


