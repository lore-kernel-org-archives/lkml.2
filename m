Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab0HJM01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 08:26:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:52552 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab0HJM0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 08:26:21 -0400
Date: Tue, 10 Aug 2010 14:26:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@suse.de>, linux-usb <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH trivial] drivers/usb: Remove unnecessary return;s from
 void functions
In-Reply-To: <cf728d0aede04dbccdc924d240a053318e06b11a.1280943205.git.joe@perches.com>
Message-ID: <alpine.LNX.2.00.1008101425500.2702@pobox.suse.cz>
References: <cf728d0aede04dbccdc924d240a053318e06b11a.1280943205.git.joe@perches.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010, Joe Perches wrote:

> Greg prefers this to go through the trivial tree.
> http://lkml.org/lkml/2010/6/24/1
>
> 
> There are about 2500 void functions in drivers/usb
> Only a few used return; at end of function.
> 
> Standardize them a bit.
> 
> Moved a statement down a line in drivers/usb/host/u132-hcd.c
> 
> Signed-off-by: Joe Perches <joe@perches.com>

As Greg didn't have any objections, and the patch makes sense, I have 
applied it to my tree now, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
