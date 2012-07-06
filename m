Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160Ab2GFMSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 08:18:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55223 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab2GFMSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 08:18:35 -0400
Message-ID: <4FF6D797.6040307@gmail.com>
Date: Fri, 06 Jul 2012 07:18:31 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Wu <josh.wu@atmel.com>, Hong Xu <hong.xu@atmel.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: linux-next: manual merge of the dt-rh tree with the l2-mtd tree
References: <20120706145131.2d590abbdd53af03f4913846@canb.auug.org.au>
In-Reply-To: <20120706145131.2d590abbdd53af03f4913846@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 11:51 PM, Stephen Rothwell wrote:
> Hi Rob,
> 
> Today's linux-next merge of the dt-rh tree got a conflict in
> Documentation/devicetree/bindings/mtd/atmel-nand.txt between commit
> 348d200508b1 ("mtd: at91: add dt parameters for Atmel PMECC") from the
> l2-mtd tree and commit e7e88f9f8aeb ("of: fix a few typos in the binding
> documentation") from the dt-rh tree.
> 
> The former replaced the text (and fixed the typo) fixed by the latter, so
> I used that.

I've dropped the conflicting hunk from that patch.

Rob

