Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab1HXEoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 00:44:16 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:65263 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1HXEoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 00:44:15 -0400
Date: Wed, 24 Aug 2011 06:44:13 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] memblock: add memblock_start_of_DRAM()
Message-ID: <20110824044412.GA17879@merkur.ravnborg.org>
References: <20110806185923.GA8494@merkur.ravnborg.org> <20110823140309.9a7b36dd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823140309.9a7b36dd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 02:03:09PM -0700, Andrew Morton wrote:
> On Sat, 6 Aug 2011 20:59:23 +0200
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > SPARC32 require access to the start address.
> > Add a new helper memblock_start_of_DRAM() to give
> > access to the address of the first memblock - which
> > contains the lowest address.
> > 
> 
> What is the status of the sparc32 patches which need this change?
Not at all ready yet :-(

> If they're in some other tree then I'd suggest that this patch (which
> needed some small changes for current mainline) join them in that tree.
> 
> Or we could slip this change into mainline immediately if that makes
> life easier.
> 
> Or we could just wait for 3.1.
I expect this to either go in via Tejuns memblock patches
or via the sparc32 patches.
I made the patch public this early only in case other needed the same.

	Sam
