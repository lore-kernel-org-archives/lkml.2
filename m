Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab0IYVdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 17:33:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35447
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753880Ab0IYVdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 17:33:43 -0400
Date: Sat, 25 Sep 2010 14:34:03 -0700 (PDT)
Message-Id: <20100925.143403.226762219.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.36-rc regression] occasional complete system hangs on
 sparc64 SMP
From: David Miller <davem@davemloft.net>
In-Reply-To: <19614.12985.649827.886053@pilspetsen.it.uu.se>
References: <19611.34846.813757.309183@pilspetsen.it.uu.se>
	<20100923.120935.173861259.davem@davemloft.net>
	<19614.12985.649827.886053@pilspetsen.it.uu.se>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Sat, 25 Sep 2010 19:34:49 +0200

> Update: I got another hang with 2.6.36-rc5, then went back to
> 2.6.36-rc1 which hung twice.  SYSRQ would print help text and
> the name of the command but not print anything useful on the
> console.  Now trying some of the 2.6.35-git snapshots before -rc1.

If you can somehow coerce a SysRQ-y combo to work, that's
the most likely way to get the information necessary to
debug this.
