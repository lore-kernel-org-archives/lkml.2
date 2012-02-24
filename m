Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab2BXTz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:55:29 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:39404 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab2BXTz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:55:28 -0500
Date: Fri, 24 Feb 2012 14:53:13 -0500 (EST)
Message-Id: <20120224.145313.1945472951961198905.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: marek.belisko@gmail.com, dkukawka@suse.de, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, jkosina@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] Staging: ft1000-pcmcia: print MAC via printk
 format specifier
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330091162-8141-11-git-send-email-danny.kukawka@bisect.de>
References: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
	<1330091162-8141-11-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 24 Feb 2012 11:53:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Danny, please don't do this.

If you are posting a "patch series" that you want me to apply, then
that entire series must be posted to netdev for review.

Otherwise I get a partial patch series recorded in patchwork which
screws up my work flow completely.
