Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab1DSEOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 00:14:18 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:60559 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab1DSEOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 00:14:17 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 6/6] overlay: overlay filesystem documentation
To: NeilBrown <neilb@suse.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, hramrach@centrum.cz,
        Miklos Szeredi <mszeredi@suse.cz>
In-Reply-To: <20110419135818.024cd289@notabene.brown>
References: <1303142440-26328-1-git-send-email-miklos@szeredi.hu> <1303142440-26328-7-git-send-email-miklos@szeredi.hu> <7795.1303182317@jrobl> <20110419135818.024cd289@notabene.brown>
Date: Tue, 19 Apr 2011 13:13:53 +0900
Message-ID: <6291.1303186433@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


NeilBrown:
> Only to top level of an overlay stack is writable.  All others are or should
> be read only.  So only the top level can change.
>
> So in your example, fileA will be copied from ro1 directly into rwN where it
> will then be appended to.

I see.
When I have time, I will try building overlayfs.
Thank you.


J. R. Okajima
