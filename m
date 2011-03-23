Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab1CWENC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 00:13:02 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36091 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1CWENB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 00:13:01 -0400
Date: Wed, 23 Mar 2011 05:12:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, Bernhard Kaindl <bk@suse.de>,
        Andi Kleen <andi@firstfloor.org>, linux-usb@vger.kernel.org
Subject: Re: debugging a modern laptop ...
Message-ID: <20110323041256.GD21838@one.firstfloor.org>
References: <20110323034214.GC15541@MAIL.13thfloor.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323034214.GC15541@MAIL.13thfloor.at>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> most modern devices have at least one usb port, but as far
> as I could figure out via google, there is no support for
> console or similar over usb (serial or not) atm
> (please feel free to correct me here :)

There is also USB debugport, but you need a quite expensive cable
(~$100) for it. Usually it only works on one of the USB ports.

> 
> after some research, I also found a quite antique project
> exploiting the ieee1394 DMA feature, called firescope and
> after some issues finding the latest version of the tool and
> of course getting a firewire cable, there seems to be some
> kind of interaction between the monitoring system and the
> device in question, but it seems that a few problems exist
> and I didn't manage to get any relevant information that
> way yet (please let me know if that is still maintained)

It works, but you need to enable it of course. The printk
buffer hasn't changed for a long time.

The only problem often is that it doesn't support memory >4GB,
however it turns out that some LSI chips support >4GB DMA
and with those it works too.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
