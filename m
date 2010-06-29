Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0F2M5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:57:06 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:34636 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab0F2M5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:57:03 -0400
Message-ID: <4C29ED91.2010309@bfs.de>
Date: Tue, 29 Jun 2010 14:56:49 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Kulikov Vasiliy <segooon@gmail.com>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/25] r852: remove casts from void*
References: <1277806498-30738-1-git-send-email-segooon@gmail.com> <20100629123850.GO19184@bicker>
In-Reply-To: <20100629123850.GO19184@bicker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dan Carpenter schrieb:
> On Tue, Jun 29, 2010 at 02:14:57PM +0400, Kulikov Vasiliy wrote:
>> Remove unnesessary casts from void*.
>>
> 
> 1) The subjects are not helpful.  This one should say something about
> "mtd" but it doesn't.
> 2) These haven't been run through checkpatch.pl.  In fact, I can't be 
> certain anyone looked at these patches when I see things like:
> 
> -    if((( lp = (struct wl_private *)dev->priv ) != NULL ) &&
> -          !( lp->flags & WVLAN2_UIL_BUSY )) {
> +    if((( lp = dev->priv ) != NULL ) &&
> +       !( lp->flags & WVLAN2_UIL_BUSY )) {
> 
> On the recieving end, someone has to review every patch that gets merged.
> 


same problem in drivers/scsi/sg.c but that would requiere a additional patch.

re,
 wh

