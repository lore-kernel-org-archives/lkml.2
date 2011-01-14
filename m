Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1ANFik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 00:38:40 -0500
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:36121 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1ANFif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 00:38:35 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: vfs-scale, nd->inode after __do_follow_link()
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Nick Piggin <npiggin@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110114052813.GZ19804@ZenIV.linux.org.uk>
References: <7352.1294971049@jrobl> <AANLkTinXPOSxHPtffqe3m5MWppDfr6kFVMsd6k7-dkic@mail.gmail.com> <20110114052813.GZ19804@ZenIV.linux.org.uk>
Date: Fri, 14 Jan 2011 14:38:31 +0900
Message-ID: <10161.1294983511@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro:
> BTW, "i" as a name for local struct inode * is -><- that close to being a
> shootable offense.  Please, rename to e.g. struct inode *link (and it's
> struct inode, not struct dentry).

I will do so when the patch will be merged.
I meant the code snippet is just showing what I thought. I didn't mean
it should be merged.


J. R. Okajima
