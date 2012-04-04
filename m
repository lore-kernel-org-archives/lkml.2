Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab2DDMYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 08:24:45 -0400
Received: from fw.wantstofly.org ([80.101.37.227]:63277 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab2DDMYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 08:24:42 -0400
Date: Wed, 4 Apr 2012 14:24:38 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/5] ARM: remove ixp23xx and ixp2000 platforms
Message-ID: <20120404122438.GZ28523@wantstofly.org>
References: <1333503243-7702-1-git-send-email-robherring2@gmail.com>
 <4F7C3C2B.2050208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7C3C2B.2050208@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 07:18:51AM -0500, Rob Herring wrote:

> > From: Rob Herring <rob.herring@calxeda.com>
> > 
> > ixp2xxx platforms have had no real changes since ~2006 and the maintainer
> > has said on irc that they can be removed:
> > 
> > 13:05 < nico> do you still care about ixp2000?
> > 13:22 < lennert> not really, no
> > 13:58 < nico> do you think we could remove it from the kernel tree?
> > 14:01 < lennert> go for it, and remove ixp23xx too while you're at it

Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>


> > Removing will help simplify ARM consolidation in general and PCI re-work
> > specifically.

But this seems pretty specious.
