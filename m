Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab1ANElK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 23:41:10 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:48103 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1ANElH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 23:41:07 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: vfs-scale, nd->inode after __do_follow_link()
To: Nick Piggin <npiggin@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTinXPOSxHPtffqe3m5MWppDfr6kFVMsd6k7-dkic@mail.gmail.com>
References: <7352.1294971049@jrobl> <AANLkTinXPOSxHPtffqe3m5MWppDfr6kFVMsd6k7-dkic@mail.gmail.com>
Date: Fri, 14 Jan 2011 13:41:03 +0900
Message-ID: <9551.1294980063@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nick Piggin:
> > Isn't it path.dentry->d_inode instead of nd.inode?
	:::
> It should be the inode we followed, rather than the inode of the
> new path, I think.

In __do_follow_link(), path.dentry is what we followed, isn't it?

__do_follow_link()
{
	struct dentry *dentry = path->dentry;
	;;;
	*p = dentry->d_inode->i_op->follow_link(dentry, nd);
	;;;


J. R. Okajima
