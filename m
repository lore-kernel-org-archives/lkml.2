Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab2F0Q3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 12:29:32 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43771 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758110Ab2F0Q3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 12:29:30 -0400
Message-ID: <1340814569.16533.53.camel@joe2Laptop>
Subject: Re: linux-next: Tree for Jun 27 (eliminated_printk)
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 27 Jun 2012 09:29:29 -0700
In-Reply-To: <4FEB340D.3040908@xenotime.net>
References: <20120627132217.f8bbdd1f467711419123d188@canb.auug.org.au>
	 <4FEB340D.3040908@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 09:25 -0700, Randy Dunlap wrote:
> On 06/26/2012 08:22 PM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > This tree was not built between each merge, but only after merging all
> > the trees.
> > 
> > Changes since 20120626:
> 
> 
> 
> on i386:
> 
> drivers/platform/x86/thinkpad_acpi.c: In function 'drv_acpi_handle_init':
> drivers/platform/x86/thinkpad_acpi.c:684:2: error: implicit declaration of function 'eliminated_printk'
> 
> drivers/platform/x86/fujitsu-laptop.c: In function 'call_fext_func':
> drivers/platform/x86/fujitsu-laptop.c:223:3: error: implicit declaration of function 'eliminated_printk'
> 
> 
> Full randconfig file is attached.

Thanks Randy.

This patch depends on the first patch in the series
which hasn't been applied.

https://lkml.org/lkml/2012/6/17/229
https://lkml.org/lkml/2012/6/17/231


