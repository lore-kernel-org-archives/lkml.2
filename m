Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab2AUTWj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 14:22:39 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:57527 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751036Ab2AUTWi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 14:22:38 -0500
MIME-Version: 1.0
In-Reply-To: <1327164143.2050.9.camel@joe2Laptop>
References: <1327140612-9694-1-git-send-email-solid.se7en@gmail.com>
	<1327140612-9694-3-git-send-email-solid.se7en@gmail.com>
	<1327164143.2050.9.camel@joe2Laptop>
Date: Sat, 21 Jan 2012 11:22:38 -0800
Message-ID: <CAEMzQTZZnPfGK4CZGw+PraL59f4C8eADfvpaGUrVd38d5TFA+A@mail.gmail.com>
Subject: Re: [PATCH 3/3] xgifb: checkpatch cleanup, printk() KERN_*
From: sam hansen <solid.se7en@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One other thing.  It would be better to add
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> before any #include and convert all the
> printks(KERN_<LEVEL> to pr_<level>(
> stripping all the leading XGIfb: too.

So, an administrative question.  Sorry for my noob-ishness but... I
will be 1) modifying the patch regarding prink to use pr_LVL (and a
few logic tweaks), and will also be introducing a new patch to set up
the pr_fmt macro for kbuild.  I can find lots of information regarding
how to create/submit a patch, but not a lot of information about how
to modify/resubmit a patch you've already submitted and received
feedback for.

The pr_fmt patch will likely just be a new patch outside of this patch
set?  Or should I use git-rebase to work it in the middle of the patch
set and regenerate/resend all patches (this approach doesn't seem to
make sense).

I'm not sure how the git commit short-hashes work with the patches,
and I don't want to destroy that information because it seems like
it's important when stuff goes upstream?

Thanks for any feedback you guys may have :)

And thanks for helping me pull myself up to actually being useful to you all.

~s
