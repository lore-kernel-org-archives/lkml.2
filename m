Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031357Ab2COAUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:20:31 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:27523 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab2COAU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:20:28 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 108.39.66.94
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/SfmtwbdQ0BuHQxR67K1+hOBO3mW3c+bg=
Date: Wed, 14 Mar 2012 20:20:20 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, Michael Walle <michael@walle.cc>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (arm-soc tree related)
Message-ID: <20120315002020.GA16189@titan.lakedaemon.net>
References: <20120315105901.7b10c9f4de9374a613436988@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315105901.7b10c9f4de9374a613436988@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 10:59:01AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allmodconfig) failed like this:
> 
> drivers/ata/sata_mv.c:4185:1: error: '__mod_of_device_table' aliased to undefined symbol 'mvsdio_dt_ids'
> 
> Caused by commit f1e1e148c5cb ("ARM: kirkwood: sata_mv: add device tree
> binding").

Stephen,

That's my mistake.  I did a pull request for the wrong branch.  Olof,
could you please drop the offending branch and I'll submit a new pull
request once I have a chance to test Arnd's irq patch?

thx,

Jason.
