Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab0IEMJE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 08:09:04 -0400
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:39292 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab0IEMJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 08:09:03 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/6] overlay filesystem prototype
To: Neil Brown <neilb@suse.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, vaurora@redhat.com,
        viro@zeniv.linux.org.uk
In-Reply-To: <20100905214452.797527a7@notabene>
References: <20100903134116.039612691@szeredi.hu> <20970.1283683030@jrobl> <20100905214452.797527a7@notabene>
Date: Sun, 05 Sep 2010 21:08:16 +0900
Message-ID: <23500.1283688496@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Neil Brown:
> > Although it may be harmless, write-ref will not be put when a user
> > executes,
> > - mount -o ro /overlay
>              ^remount,   I assume

Right.


> Something like this?

Exactly.


J. R. Okajima
