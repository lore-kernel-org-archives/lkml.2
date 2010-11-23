Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab0KWQ1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 11:27:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38275
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994Ab0KWQ1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 11:27:35 -0500
Date: Tue, 23 Nov 2010 08:28:00 -0800 (PST)
Message-Id: <20101123.082800.189699339.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath5k-devel@venema.h4ckr.net, ath9k-devel@venema.h4ckr.net,
        libertas-dev@lists.infradead.org, users@rt2x00.serialmonkey.com,
        linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de
Subject: Re: [PATCH 00/62] drivers/net: Use static const
From: David Miller <davem@davemloft.net>
In-Reply-To: <1290465605.27683.52.camel@Joe-Laptop>
References: <1290463846.27683.36.camel@Joe-Laptop>
	<20101122.141939.226774888.davem@davemloft.net>
	<1290465605.27683.52.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 22 Nov 2010 14:40:05 -0800

> I'll see who picks up or acks what and send a pull request to
> you for the remainder of these patches mid December or so.

Thanks.

> Do you want micro patches or a single patch?

You can group them by directory or similar if you like.

F.e.:

Patch 1: drivers/net/*.c
Patch 2: drivers/net/*/*.c (wired drivers)
Patch 3: drivers/net/wireless/*

Thanks again.
