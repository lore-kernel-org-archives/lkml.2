Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab0JBOV1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 10:21:27 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47850 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755624Ab0JBOVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 10:21:25 -0400
Date: Sat, 2 Oct 2010 16:21:23 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: walter harms <wharms@bfs.de>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>, kernel-janitors@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] drivers/atm/idt77252.c: Remove unnecessary error
 check
In-Reply-To: <4CA73D26.7090109@bfs.de>
Message-ID: <Pine.LNX.4.64.1010021621000.21879@ask.diku.dk>
References: <1286027958-7333-4-git-send-email-julia@diku.dk> <4CA73D26.7090109@bfs.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Oct 2010, walter harms wrote:

> 
> 
> Julia Lawall schrieb:
> > This code does not call deinit_card(card); in an error case, as done in
> > other error-handling code in the same function.  But actually, the called
> > function init_sram can only return 0, so there is no need for the error
> > check at all.
> > 
> 
> 
> did you set init_sram() to void ?

No, that indeed seems like a reasonable change.  Patch shortly.

julia
