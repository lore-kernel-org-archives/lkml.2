Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab0G1HLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:11:23 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56291 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab0G1HLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:11:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=BvU8ip5NxY7JxG0/K2My/zyNwVJYZnIymzBCMGqmmbAK44yo/0ixvtxIwwfYfFgoKQ
         Oyx30nB6Q1t74VULpjoh8efw7WqYES4wY1cMPFRkmFfQ03zSWEVPjLqikiRmvbFsy6Fs
         quUv6LXfF7FIo+odTwgvVw28cJ8zfE9gKUZv0=
MIME-Version: 1.0
In-Reply-To: <20100727120805.f583c70b.sfr@canb.auug.org.au>
References: <20100727120805.f583c70b.sfr@canb.auug.org.au>
Date: Wed, 28 Jul 2010 00:11:19 -0700
X-Google-Sender-Auth: WuGcpLFfhZuxeNW4FIjMrQwoHJI
Message-ID: <AANLkTin4EAQ48HP3ETDUMqBe2AzcznRuZdBdG+_RhR8x@mail.gmail.com>
Subject: Re: linux-next: manual merge of the async_tx tree with the arm tree
From: Dan Williams <dan.j.williams@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 7:08 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Dan,
>
> Today's linux-next merge of the async_tx tree got a conflict in
> arch/arm/mach-ux500/devices-db8500.c between commit
> 6055930cba8fdb2c8855b32bae262aaf69c1fdb4 ("ARM: 6266/1: ux500: add
> separate irq lists for DB8500 and DB5500") from the arm tree and commit
> 5aa12e8c9c57741606e52f43e62ab1b9dc8e9dcc ("DMAENGINE: ste_dma40: arch
> updates for LCLA and LCPA") from the async_tx tree.
>
> I fixed it up (I think - see below) and can carry the fix as necessary.
> --

Thanks Stephen!

Russell, the dma40 driver updates and related arch fixups have been
sitting in next for a month, I'd prefer not to lose this baseline.
Assuming this change is brand new any chance the dma40 specific part
of this patch can be peeled off and sent through my tree, or are you
in a similar "can't/won't" rebase position?

--
Dan
