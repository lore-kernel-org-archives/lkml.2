Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab0JBCWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 22:22:45 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51439 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab0JBCWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 22:22:44 -0400
Date: Fri, 1 Oct 2010 19:24:54 -0700
From: Andres Salomon <dilinger@queued.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        driverdevel <devel@driverdev.osuosl.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>
Subject: Re: linux-next: Tree for October 1 (staging/olpc_dcon)
Message-ID: <20101001192454.0a427cb0@debxo>
In-Reply-To: <20101001154531.997630a2.randy.dunlap@oracle.com>
References: <20101001153756.47b52566.sfr@canb.auug.org.au>
	<20101001154531.997630a2.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Oct 2010 15:45:31 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Fri, 1 Oct 2010 15:37:56 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20100930:
> 
> 
> drivers/staging/olpc_dcon/olpc_dcon_xo_1.c:57: error: implicit
> declaration of function 'geode_gpio_event_irq'
> drivers/staging/olpc_dcon/olpc_dcon_xo_1.c:57: error: implicit
> declaration of function 'geode_gpio'

Yep, it's pending a cs5535-gpio patch
(https://patchwork.kernel.org/patch/209482/).
