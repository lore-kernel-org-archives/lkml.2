Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab1FFQZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:25:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60201 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab1FFQY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:24:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor management driver
Date: Mon, 6 Jun 2011 18:24:53 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Deepak Saxena <dsaxena@linaro.org>, kumar.gala@freescale.com,
        benh@kernel.crashing.org, greg@kroah.com, akpm@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-console@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <201106061803.58531.arnd@arndb.de> <4DECFBC5.6070205@freescale.com>
In-Reply-To: <4DECFBC5.6070205@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106061824.53844.arnd@arndb.de>
X-Provags-ID: V02:K0:mErMdGC9upd7iSA/5WA8RzPQ58MASI7xOZKK+naenny
 FNxSkNzjaxq7qkOLlNGWJUrbrLKSqoQ/6moIvvZwXJ6Mx/Gk/m
 yWXdM0YkHKsv/n2g13uIgkBdUQA0pUIyKauLGhFqmsXodAUsQW
 /Y2Le8xa5vDGZbWF1w0AMI9Be+CCQtfSHCM42bnmoyO3w3EN1j
 ltMu+DbQ0bWqtViDGzI/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 June 2011, Timur Tabi wrote:
> Arnd Bergmann wrote:
> > When we talked about the situation of drivers/misc and drivers/char at
> > one of the recent conferences, a broad consensus was that they are in
> > need of a maintainer, which I foolishly signed up for. Deepak wanted
> > to send an update to the MAINTAINERS file for this (I guess I can do
> > that too, since he must have forgotten about it), but the main idea is
> > that I'm there to say no to any driver that someone tries to add there,
> > unless there are really good reasons why it is actually a good place
> > to live for that driver.
> 
> Can you give me an example of a driver that does belong in drivers/misc?

Not really.

> Frankly, I just don't see what's wrong with a repository of various drivers that
> don't really belong anywhere else.

The main problem is that for the most part it's a pile of crap that
nobody wants to look at, so drivers getting added there see basically
no real review.

> And what about my concern that my driver will be the only one in drivers/virt?

I have no doubt that more of these will come. Chris Metcalf is currently
looking for a home for his tilera hypervisor drivers, and we have the
microsoft hyperv drivers in drivers/staging, so they will hopefully
move to a proper place later. We also have similar drivers in other
places, e.g. drivers/ps3/ps3-sys-manager.c, drivers/s390/char/vmcp.c
or parts of drivers/xen.

	Arnd
