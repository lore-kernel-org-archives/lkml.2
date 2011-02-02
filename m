Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab1BBA6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:58:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab1BBA6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:58:21 -0500
Date: Wed, 2 Feb 2011 11:58:13 +1100
From: NeilBrown <neilb@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the md-current tree
Message-ID: <20110202115813.1ee7ab4d@notabene.brown>
In-Reply-To: <20110202112519.7a4d2bd3.sfr@canb.auug.org.au>
References: <20110202112519.7a4d2bd3.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Feb 2011 11:25:19 +1100 Stephen Rothwell <sfr@canb.auug.org.au>
wrote:

> Hi Neil,
> 
> After merging the md-current tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/md/md.c: In function 'slot_store':
> drivers/md/md.c:2466: error: 'mddev' undeclared (first use in this function)
> 
> Caused by commit 778f14598b2924e92790ddd8a167424d2894ffb0 ("md: Don't
> allow slot_store while resync/recovery is happening").
> 
> Please build test your tree before publishing it.
> 
> I have used the md-current tree from next-20110201 for today.
> 

Ouch... I blame the heat!!

Fix now, thanks.

NeilBrown

