Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1B1TXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 14:23:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50162
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712Ab1B1TXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 14:23:13 -0500
Date: Mon, 28 Feb 2011 11:23:49 -0800 (PST)
Message-Id: <20110228.112349.104067277.davem@davemloft.net>
To: segoon@openwall.com
Cc: mjt@tls.msk.ru, arnd@arndb.de, mirqus@gmail.com, bhutchings@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, eric.dumazet@gmail.com,
        therbert@google.com, xiaosuo@gmail.com, jesse@nicira.com,
        kees.cook@canonical.com, eugene@redhat.com, dan.j.rosenberg@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH] don't allow CAP_NET_ADMIN to load non-netdev kernel
 modules
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110228095133.GA4351@albatros>
References: <201102272122.52643.arnd@arndb.de>
	<4D6B6AE7.2050202@msgid.tls.msk.ru>
	<20110228095133.GA4351@albatros>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>
Date: Mon, 28 Feb 2011 12:51:33 +0300

> David, are you OK with this way?

Sure.
