Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab1L1R5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 12:57:55 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:28405 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753832Ab1L1R5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 12:57:53 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtkKAARX+05tgySC/2dsb2JhbABDqx6BOoEGgXIBAQQBOhwjBQsIAw44FCUDIYgNArVCE4sZYwSVAYkdiRk
Date: Wed, 28 Dec 2011 18:57:51 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Marc Vertes <marc.vertes@sigfox.com>, linux-watchdog@vger.kernel.org
Subject: Re: linux-next: Tree for Dec 28 (via_wdt)
Message-ID: <20111228175751.GA14460@infomag.iguana.be>
References: <20111228201806.d6de27fa2dbd9e3a3b7a2603@canb.auug.org.au> <4EFB5BF2.3020600@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EFB5BF2.3020600@xenotime.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randi,

> via_wdt needs a MODULE_LICENSE():
> 
> WARNING: modpost: missing MODULE_LICENSE() in drivers/watchdog/via_wdt.o
> see include/linux/module.h for more information

Fixed.

Thanks,
Wim.

