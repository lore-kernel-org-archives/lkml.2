Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab0ESLAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:00:49 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:40830 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab0ESLAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:00:48 -0400
Date: Wed, 19 May 2010 13:00:30 +0200
From: Daniel Mack <daniel@zonque.org>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Paul Mundt <lethal@linux-sh.org>,
       Magnus Damm <damm@igel.co.jp>,
       Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>,
       Andrea Gelmini <andrea.gelmini@gelma.net>, linux-usb@vger.kernel.org
Subject: =?utf-8?Q?drivers=2Fusb=2Fgadget=2Fr8a6659?=
	=?utf-8?B?Ny11ZGMuaDoxMzk6IHdhcm5pbmc6IOKAmGRhdGE=?=
	=?utf-8?B?4oCZ?= may be used uninitialized in this function
Message-ID: <20100519110030.GG30804@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I stumbled over the r8a66597 UDC gadget driver as the the compiler
complained about the static inline function r8a66597_read():

drivers/usb/gadget/r8a66597-udc.c: In function ‘irq_packet_read’:
drivers/usb/gadget/r8a66597-udc.h:139: warning: ‘data’ may be used uninitialized in this function
drivers/usb/gadget/r8a66597-udc.h:139: note: ‘data’ was declared here

I know nothing about the code, but this function indeed looks bogus. Can
anyone have a look at this? Also, I wonder whether this function is
actually too big for a static inline.

Thanks,
Daniel

