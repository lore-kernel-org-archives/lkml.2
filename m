Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab1DRA5r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 20:57:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33766
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753729Ab1DRA5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 20:57:36 -0400
Date: Sun, 17 Apr 2011 17:57:01 -0700 (PDT)
Message-Id: <20110417.175701.209965647.davem@davemloft.net>
To: joe@perches.com
Cc: mr.nuke.me@gmail.com, rl@hellgate.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] via-rhine: Assign random MAC address if necessary
From: David Miller <davem@davemloft.net>
In-Reply-To: <c7efaaf6a943f911162261edd7a2186086cda953.1302998994.git.joe@perches.com>
References: <4DAA12C0.7030106@gmail.com>
	<cover.1302998994.git.joe@perches.com>
	<c7efaaf6a943f911162261edd7a2186086cda953.1302998994.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 16 Apr 2011 17:15:26 -0700

> Roger Luethi has had several reports of Rhine NICs providing
> an invalid MAC address.  If so, assign a random MAC address so
> the hardware can still be used.
> 
> Tested as a standalone interface, as carrier for ppp, and as a
> bonding slave.
> 
> Original-patch-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
