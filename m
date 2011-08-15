Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1HONXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 09:23:55 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54945 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab1HONXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 09:23:53 -0400
Date: Mon, 15 Aug 2011 09:23:49 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Arnd Bergmann <arnd@arndb.de>
cc: Leo Yan <leoy@marvell.com>, linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <hzhuang1@marvell.com>
Subject: Re: [PATCH 1/3] ARM: mmp: add sram allocator
In-Reply-To: <1403041.Yj2MdIhcZO@wuerfel>
Message-ID: <alpine.LFD.2.00.1108150920060.20358@xanadu.home>
References: <1313377794-26721-1-git-send-email-leoy@marvell.com> <1313377794-26721-2-git-send-email-leoy@marvell.com> <1403041.Yj2MdIhcZO@wuerfel>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011, Arnd Bergmann wrote:

> Some time ago, there was talk of merging the existing sram drivers
> and creating a common driver that is easy to hook into.

Absolutely.

> What has happened with that? My feeling is that we should stop adding
> more drivers like this in the platform code but rather put an
> authoritative copy into arch/arm/mm/ or even the top-level mm/ directory
> and change over the existing drivers to hook into that one.

IIRC, this was driven by Russell.  Maybe this is a good time to revive 
discussion around it.


Nicolas
