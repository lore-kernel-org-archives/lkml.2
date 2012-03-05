Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab2CESlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 13:41:49 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14765 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab2CESls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 13:41:48 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18xN0yOU5ecO2Nmkc3Y3rFz
Date: Mon, 5 Mar 2012 10:41:42 -0800
From: Tony Lindgren <tony@atomide.com>
To: Uri Yosef <uri.y@variscite.com>
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        oren@variscite.com, uri.yosef@gmail.com, Uri Yosef <uri@embedox.com>
Subject: Re: [PATCH] ARM: OMAP4: Add support for Variscite OMAP4460
 System-On-Module
Message-ID: <20120305184142.GI12083@atomide.com>
References: <1326898096-4899-1-git-send-email-uri.y@variscite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326898096-4899-1-git-send-email-uri.y@variscite.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Uri Yosef <uri.y@variscite.com> [120118 06:13]:
> From: Uri Yosef <uri@embedox.com>
> 
> Add support for Variscite OMAP4460 System-On-Module and development kit board.
> Working: LCD, HDMI, USB, UART, Ethernet.

For reference, we're trying to remove board-*.c files by
changing over to device tree. So new board-*.c files will
be merged. You might want to look at booting your board
using board-generic.c and a related .dts file.

While this transition is happening, I can carry some
board-*.c files in the testing-board branch until devices
start working sufficiently for board-generic.c to be
usable.

Regards,

Tony
