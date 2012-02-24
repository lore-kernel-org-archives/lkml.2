Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab2BXUqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 15:46:18 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:39943 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029Ab2BXUqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:46:16 -0500
Date: Fri, 24 Feb 2012 15:42:24 -0500 (EST)
Message-Id: <20120224.154224.992364563810018486.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: grundler@parisc-linux.org, gregkh@linuxfoundation.org, pe1dnn@amsat.org,
        kernel@wantstofly.org, marek.belisko@gmail.com, oneukum@suse.de,
        dkukawka@suse.de, devel@driverdev.osuosl.org,
        e1000-devel@lists.sourceforge.net, geert@linux-m68k.org,
        grant.likely@secretlab.ca, jkosina@suse.cz, jpirko@redhat.com,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org, tklauser@distanz.ch
Subject: Re: [PATCH 00/11] print MAC via printk format specifier
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
References: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 24 Feb 2012 12:42:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Fri, 24 Feb 2012 14:45:51 +0100

> Print MAC/dev_addr via printk extended format specifier %pm/%pM
> instead of using custom code.
> 
> These patches are against net-next.

All applied, but you absolutely have to start posting patch series
correctly.

If it's a series for net-next, then every single patch must be
CC:'d to netdev so it gets queued up properly in patchwork.
