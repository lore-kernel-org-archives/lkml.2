Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab0GFV6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 17:58:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:40589 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab0GFV6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 17:58:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,548,1272870000"; 
   d="scan'208";a="636176740"
Date: Tue, 6 Jul 2010 22:29:54 +0100
From: Alan Cox <alan@linux.intel.com>
To: kagen101@gmail.com
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: et131x: fix coding style issues in
 et131x_initpci.c
Message-ID: <20100706222954.432ffcdd@linux.intel.com>
In-Reply-To: <1278436628.5396.75.camel@dermezel>
References: <1278436628.5396.75.camel@dermezel>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jul 2010 19:17:08 +0200
Joe Eloff <kagen101@gmail.com> wrote:

> >From e23e19537c4d62bc76ae982859d3c3225a45d9c2 Mon Sep 17 00:00:00
> >2001
> From: Joe Eloff <kagen101@gmail.com>
> Date: Tue, 6 Jul 2010 19:13:28 +0200
> Subject: [PATCH] Staging: et131x: fix coding style issues in
> et131x_initpci.c
> 
> This is a patch to the et131x_initpci.c file that fixes up all the
> line lengths over 80 by the checkpatch.pl tool.

That is one area where checkpatch can be misleading. If you split
messages like that it becomes hard to grep for them.

Where it is useful is where you have

	printk("blah blah bah blah [120 chars]", functioncall(foo))

and it would hide things like functioncall(foo)

No argument about the comment ones however.
