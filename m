Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab1DMRdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:33:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45866
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab1DMRdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:33:08 -0400
Date: Wed, 13 Apr 2011 10:32:33 -0700 (PDT)
Message-Id: <20110413.103233.193707113.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Build regressions/improvements in v2.6.39-rc3
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.1104131835280.32045@ayla.of.borg>
References: <alpine.DEB.2.00.1104131835280.32045@ayla.of.borg>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 13 Apr 2011 18:35:45 +0200 (CEST)

> 47 regressions:
>   + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/ethtool.h: error: expected specifier-qualifier-list before '__u32': 104, 90, 21, 282, 389, 460, 521, 444, 96, 297, 82, 57, 291, 258, 231, 482, 209, 510, 265, 113 => 104, 538, 90, 21, 523, 552, 266, 445, 292, 96, 82, 512, 563, 57, 259, 283, 298, 484, 390, 231, 209, 462, 574, 113

I do allmodconfig builds on sparc64 systems every single day using
various versions of gcc-4.4, gcc-4.5, and gcc-4.6

And I never ever see this build error.  Never.

If you're using a cross build environment, maybe something isn't quite
right with that?
