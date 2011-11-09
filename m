Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab1KIJZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 04:25:56 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:56876 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab1KIJZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 04:25:54 -0500
X-Auth-Info: 8vygFN2gnNPpu1hmspe1mDWXWIU5aJn3ZfHcl+hu5M0=
Date: Wed, 9 Nov 2011 10:25:40 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc/eeprom: Fix dependecy on 'PPC_MPC5200_GPIO'
Message-ID: <20111109102540.322fabe9@wker>
In-Reply-To: <1320793779.14409.415.camel@x61.thuisdomein>
References: <1320793779.14409.415.camel@x61.thuisdomein>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Nov 2011 00:09:39 +0100
Paul Bolle <pebolle@tiscali.nl> wrote:

> The driver for the DigsyMTC display configuration EEPROMs device got
> added by commit 469dded183 ("misc/eeprom: add eeprom access driver for
> digsy_mtc board"). Its Kconfig symbol depends on PPC_MPC5200_GPIO. But
> at the time that driver got added PPC_MPC5200_GPIO was already renamed
> to GPIO_MPC5200, by commit 6eae1ace68 ("gpio: Move mpc5200 gpio driver
> to drivers/gpio").
> 
> So make this driver depend on GPIO_MPC5200. And since GPIO_MPC5200 itself
> implies that GPIOLIB is set, that dependency can be dropped.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Anatolij Gustschin <agust@denx.de>

Thanks!
