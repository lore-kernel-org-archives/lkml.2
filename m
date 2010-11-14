Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab0KNTzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 14:55:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59303
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756909Ab0KNTzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 14:55:12 -0500
Date: Sun, 14 Nov 2010 11:55:36 -0800 (PST)
Message-Id: <20101114.115536.71112799.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: r0bertz@gentoo.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCH] ipv4: mitigate an integer underflow when comparing tcp
 timestamps
From: David Miller <davem@davemloft.net>
In-Reply-To: <1289724745.2743.61.camel@edumazet-laptop>
References: <1289720156-30118-1-git-send-email-r0bertz@gentoo.org>
	<1289724745.2743.61.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sun, 14 Nov 2010 09:52:25 +0100

> Really, if you have multiple clients behind a common NAT, you cannot use
> this code at all, since NAT doesnt usually change TCP timestamps.

NAT is %100 incompatible with TW recycling, full stop.

There is no maybe, or maybe not.

If you are behind NAT you must not turn this feature on, ever.
