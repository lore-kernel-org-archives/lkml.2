Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab2K1RLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:11:06 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50680 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab2K1RLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:11:05 -0500
Date: Wed, 28 Nov 2012 12:11:02 -0500 (EST)
Message-Id: <20121128.121102.711911718711110544.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: chas@cmf.nrl.navy.mil, krzysiek@podlesie.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nathan@traverse.com.au
Subject: Re: [PATCH] br2684: don't send frames on not-ready vcc
From: David Miller <davem@davemloft.net>
In-Reply-To: <1354122555.21562.92.camel@shinybook.infradead.org>
References: <1354122070.21562.89.camel@shinybook.infradead.org>
	<20121128.120415.778262714601372592.davem@davemloft.net>
	<1354122555.21562.92.camel@shinybook.infradead.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Wed, 28 Nov 2012 17:09:15 +0000

> And then I'll either send an explicit pull request, or submit it as
> patches ― whichever you prefer.

The canonical thing is to do both, send the pull request in the
"[PATCH 0/N]" email, and then the patches so everyone can see the
final form of the changes.

> Hopefully in the next day or so; the merge window is approaching...

Yep, thanks.
