Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab1F1IvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 04:51:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756957Ab1F1Ith (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 04:49:37 -0400
Date: Tue, 28 Jun 2011 10:49:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: David Miller <davem@davemloft.net>
Cc: vitalivanov@gmail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, grant.likely@secretlab.ca,
        eric.dumazet@gmail.com, tglx@linutronix.de
Subject: Re: [PATCH] treewide: fix kernel-doc warnings
In-Reply-To: <20110627.160053.10231914928438213.davem@davemloft.net>
Message-ID: <alpine.LNX.2.00.1106281048550.11049@pobox.suse.cz>
References: <1309192426.17574.47.camel@vivanov> <20110627.160053.10231914928438213.davem@davemloft.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011, David Miller wrote:

> >>From 55fe3701d1ed1f1302a73cd5bfdfc7972e89f5b7 Mon Sep 17 00:00:00 2001
> > From: Vitaliy Ivanov <vitalivanov@gmail.com>
> > Date: Mon, 27 Jun 2011 19:07:08 +0300
> > Subject: [PATCH] treewide: fix kernel-doc warnings
> > 
> > Fix 'make htmldocs' warnings:
> > 
> > Warning(/include/linux/hrtimer.h:153): No description found for
> > parameter 'clockid'
> > Warning(/include/linux/device.h:604): Excess struct/union/enum/typedef
> > member 'of_match' description in 'device'
> > Warning(/include/net/sock.h:349): Excess struct/union/enum/typedef
> > member 'sk_rmem_alloc' description in 'sock'
> > 
> > Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
