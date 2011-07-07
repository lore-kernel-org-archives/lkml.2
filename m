Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1GGODa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:03:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47008 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1GGOD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:03:27 -0400
MIME-Version: 1.0
In-Reply-To: <20110707154223.d7ecda2a6cc84e033bb0b26a@canb.auug.org.au>
References: <20110707154223.d7ecda2a6cc84e033bb0b26a@canb.auug.org.au>
Date: Thu, 7 Jul 2011 16:03:26 +0200
X-Google-Sender-Auth: T6KplujWZQEnpV3KzAPxy20p0O0
Message-ID: <CAKnu2Mr+L3XHk18wgRY87cyKt=7mDrG4bYM8hCCexgh5TjvJuw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the ux500-core tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Axel Lin <axel.lin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/7 Stephen Rothwell <sfr@canb.auug.org.au>:

> Today's linux-next merge of the staging tree got a conflict in
> arch/arm/mach-ux500/board-mop500-u8500uib.c between commit 0df7aaf0f276
> ("mach-ux500: fix build error due to unknown 'regulator_en' field") from
> the ux500-core tree and commit 857f727674f4 ("staging: ste_rmi4: remove
> cross-dependent platform data") from the staging tree.

I'll drop that patch in ux500-core.

> The second supercedes the first, so I used that.

Correct, sorry for the mess.

Yours,
Linus Walleij
