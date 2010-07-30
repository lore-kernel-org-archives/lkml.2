Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab0G3GKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 02:10:30 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62072 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab0G3GK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 02:10:29 -0400
MIME-Version: 1.0
In-Reply-To: <20100730145415.8ed17b7e.sfr@canb.auug.org.au>
References: <20100730145415.8ed17b7e.sfr@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 30 Jul 2010 00:10:08 -0600
X-Google-Sender-Auth: pkzi8l5pu2F-6oWP4Il7nLb_cYU
Message-ID: <AANLkTimuYkDkAPXTAKLW-Fdj9dyEci9PGutMRRm2k3mM@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the devicetree tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 10:54 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> After merging the devicetree tree, today's linux-next build (powerpc64
> allnoconfig) produced this warning:
>
> drivers/of/irq.c: In function 'of_irq_map_raw':
> drivers/of/irq.c:102: warning: cast from pointer to integer of different size
>
> Introduced by commit 7d12c3ee9e1843b1d19d9c308988bb163fb9aa0b ("of/irq:
> Fix endian issues in parsing interrupt specifiers").

Thanks.  fixed now and pushed out.  Silly typo.

g.
