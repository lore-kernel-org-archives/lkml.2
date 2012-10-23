Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab2JWBz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 21:55:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34801 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756320Ab2JWBz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 21:55:56 -0400
Message-ID: <1350957354.7502.22.camel@joe-AO722>
Subject: Re: mmotm 2012-10-22-17-08 uploaded (printk build errors)
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Date: Mon, 22 Oct 2012 18:55:54 -0700
In-Reply-To: <5085F14D.7060005@xenotime.net>
References: <20121023000924.C56EF5C0050@hpza9.eem.corp.google.com>
	 <5085F14D.7060005@xenotime.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-22 at 18:22 -0700, Randy Dunlap wrote:
> On 10/22/2012 05:09 PM, akpm@linux-foundation.org wrote:

Hi Randy.

> on i386, when CONFIG_PRINTK is not enabled:
[]
> case 1.  CONFIG_TTY_PRINTK=y, CONFIG_EARLY_PRINTK=y
> 
> see config-r8272

[]

> case 2.  CONFIG_TTY_PRINTK=n, CONFIG_EARLY_PRINTK=n
> 
> see config-r8274

Where do I see these configs?

I've built it here defconfig and CONFIG_PRINTK=n without warning.


