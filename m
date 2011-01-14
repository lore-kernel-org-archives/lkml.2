Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab1ANFkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 00:40:19 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:55146 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab1ANFkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 00:40:15 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: vfs-scale, nd->inode after __do_follow_link()
To: Al Viro <viro@ZenIV.linux.org.uk>, Nick Piggin <npiggin@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <10161.1294983511@jrobl>
References: <7352.1294971049@jrobl> <AANLkTinXPOSxHPtffqe3m5MWppDfr6kFVMsd6k7-dkic@mail.gmail.com> <20110114052813.GZ19804@ZenIV.linux.org.uk> <10161.1294983511@jrobl>
Date: Fri, 14 Jan 2011 14:40:11 +0900
Message-ID: <10175.1294983611@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"J. R. Okajima":
> Al Viro:
> > BTW, "i" as a name for local struct inode * is -><- that close to being a
> > shootable offense.  Please, rename to e.g. struct inode *link (and it's
> > struct inode, not struct dentry).
>
> I will do so when the patch will be merged.
> I meant the code snippet is just showing what I thought. I didn't mean
> it should be merged.

Forgot to write.
I noticed about the "struct dentry" too and it was fixed in my second code.

J. R. Okajima
