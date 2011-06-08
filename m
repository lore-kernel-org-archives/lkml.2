Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab1FHPuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 11:50:09 -0400
Received: from mail.perches.com ([173.55.12.10]:2624 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab1FHPuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 11:50:06 -0400
Subject: Re: doc?
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Andrew Murray <amurray@mpcdata.com>
Cc: wangyanqing <udknight@gmail.com>, namhyung@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110608082548.8ab682fd.rdunlap@xenotime.net>
References: <20110608104057.GA11680@ahead>
	 <20110608082548.8ab682fd.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 08:50:05 -0700
Message-ID: <1307548205.27558.3.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 08:25 -0700, Randy Dunlap wrote:
> On Wed, 8 Jun 2011 10:40:58 +0000 wangyanqing wrote:
> > I can't find the information
> > from Documentation/printk-formats.txt. 
> It wouldn't hurt to add some docs, yes, but for now the %p
> extensions are all documented in lib/vsprintf.c, just above
> function pointer(), around line 802 in 3.0-rc2.

Awhile back Andrew Murray proposed a patch.
Maybe he'll get back to it.

https://lkml.org/lkml/2011/2/5/212


