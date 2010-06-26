Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab0FZEbR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 00:31:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36985
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033Ab0FZEbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 00:31:16 -0400
Date: Fri, 25 Jun 2010 21:31:28 -0700 (PDT)
Message-Id: <20100625.213128.220048816.davem@davemloft.net>
To: tilman@imap.cc
Cc: isdn@linux-pingi.de, hjlipp@web.de, keil@b1-systems.de,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/5] late Gigaset fixes for 2.6.35
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100622-patch-gigaset-00.tilman@imap.cc>
References: <20100622-patch-gigaset-00.tilman@imap.cc>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Tue, 22 Jun 2010 01:54:04 +0200 (CEST)

> following are five patches to the Gigaset driver fixing reported
> problems with two CAPI applications (Asterisk and capifax). They
> fix serious bugs, though not technically regressions, and I would
> therefore appreciate if they could still make it into release
> 2.6.35.

All applied to net-2.6, thanks.
