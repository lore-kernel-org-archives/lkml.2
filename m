Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab0G0Vnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 17:43:39 -0400
Received: from mail.perches.com ([173.55.12.10]:2134 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab0G0Vnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 17:43:37 -0400
Subject: Re: [PATCH net-next] drivers/net/vxge: Use pr_<level>, fix logging
 macros
From: Joe Perches <joe@perches.com>
To: Jon Mason <jon.mason@exar.com>
Cc: Ramkrishna Vepa <Ramkrishna.Vepa@exar.com>,
        Sreenivasa Honnur <Sreenivasa.Honnur@exar.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100727213819.GC25556@exar.com>
References: <1280263388.24054.27.camel@Joe-Laptop.home>
	 <20100727213819.GC25556@exar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 14:43:35 -0700
Message-ID: <1280267015.24054.42.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-27 at 16:38 -0500, Jon Mason wrote:
> On Tue, Jul 27, 2010 at 01:43:08PM -0700, Joe Perches wrote:
> > Use direct printing of logging messages to save text.
> I have a similar patch queued internally (pending testing).

Great.

[]

> Why not make the entire vxge_debug part of vxge_debug_ll?  If
> disabled, that code can be removed completely as it is unnecessary.
> Also, why not call printk directly from vxge_debug?  This code had too
> many levels of indirection before, remove all of them (as that is way
> I did in the internal patch).

'cause I don't really want to figure out the nesting,
I just want it to be smaller and easier to understand.

> I did not have any of these changes in my patch.  If you want to push
> this seperately, I ack it.

I'll resend separately.

cheers, Joe

