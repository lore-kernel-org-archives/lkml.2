Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab2KWV7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 16:59:53 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:37604 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab2KWV7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 16:59:51 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of/address: sparc: Declare of_iomap as an extern function for sparc again
To: David Miller <davem@davemloft.net>, andreas@gaisler.com
Cc: sam@ravnborg.org, rob.herring@calxeda.com, sparclinux@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
In-Reply-To: <20121123.142110.835354734152648777.davem@davemloft.net>
References: <1353669849-23697-1-git-send-email-andreas@gaisler.com> <20121123.142110.835354734152648777.davem@davemloft.net>
Date: Fri, 23 Nov 2012 21:59:46 +0000
Message-Id: <20121123215947.02DDC3E1EC4@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2012 14:21:10 -0500 (EST), David Miller <davem@davemloft.net> wrote:
> From: Andreas Larsson <andreas@gaisler.com>
> Date: Fri, 23 Nov 2012 12:24:09 +0100
> 
> > This bug-fix makes sure that of_iomap is defined extern for sparc so that the
> > sparc-specific implementation of_iomap is once again used when including
> > include/linux/of_address.h in a sparc context. OF_GPIO that is now available for
> > sparc relies on this.
> > 
> > The bug was inadvertently introduced in a850a75, "of/address: add empty static
> > inlines for !CONFIG_OF", that added a static dummy inline for of_iomap when
> > !CONFIG_OF_ADDRESS. However, CONFIG_OF_ADDRESS is never defined for sparc, but
> > there is a sparc-specific implementation /arch/sparc/kernel/of_device_common.c.
> > 
> > This fix takes the same approach as 0bce04b that solved the equivalent problem
> > for of_address_to_resource.
> > 
> > Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> 
> Grant, can you possibly merge this to Linus while I'm travelling?
> That would help me a lot.

Yup, I'm doing it right now.

g.

