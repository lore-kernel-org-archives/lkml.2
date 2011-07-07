Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1GGRHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 13:07:15 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51814 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab1GGRHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 13:07:12 -0400
MIME-Version: 1.0
In-Reply-To: <20110707.081839.2119597618388053074.davem@davemloft.net>
References: <20110707172544.867b980a1196db005b577c14@canb.auug.org.au>
 <20110707081202.6dddcbce.randy.dunlap@oracle.com> <20110707.081839.2119597618388053074.davem@davemloft.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 7 Jul 2011 13:06:51 -0400
Message-ID: <CAMjpGUfBL8wL_pBKWcfopOWFnZUG=u17LWjtECV6ubOVXn+vBQ@mail.gmail.com>
Subject: Re: linux-next: Tree for July 7 (net/af_packet)
To: David Miller <davem@davemloft.net>
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 11:18, David Miller wrote:
> packet: Fix build with INET disabled.
>
> af_packet.c:(.text+0x3d130): undefined reference to `ip_defrag'
> or
> ERROR: "ip_defrag" [net/packet/af_packet.ko] undefined!

fixes some Blackfin boards too.
Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
