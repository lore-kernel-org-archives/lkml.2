Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab2BKK3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 05:29:33 -0500
Received: from mga03.intel.com ([143.182.124.21]:12339 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab2BKK3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 05:29:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="65592678"
Date: Sat, 11 Feb 2012 10:43:20 +0000
From: Alan Cox <alan@linux.intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Feb 10 (sep_crypto)
Message-ID: <20120211104320.1ba5d23d@bob.linux.org.uk>
In-Reply-To: <4F35DB8D.8090706@xenotime.net>
References: <20120210171937.6b3e08e6b34c79416181a362@canb.auug.org.au>
	<4F35DB8D.8090706@xenotime.net>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Feb 2012 19:07:57 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On 02/09/2012 10:19 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20120209:
> 
> > ----------------------------------------------------------------------------
> 
> 
> on x86_64:
> 
> sep_crypto.c:(.text+0x155d32): undefined reference to
> `ablkcipher_walk_phys' drivers/built-in.o: In function `sep_dequeuer':

Thanks.. Will take a look Monday. I think I know what that is.

Alan
