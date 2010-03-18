Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab0CRTTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 15:19:44 -0400
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:38931 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab0CRTTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 15:19:43 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [RFC PATCH] Show data flow for file copyup in unions
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Dmitry Monakhov <dmonakhov@openvz.org>,
       Jeff Layton <jlayton@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100318175543.GA30924@shell>
References: <20100316181711.GB24819@shell> <20335.1268779891@jrobl> <20100318005358.GA24348@shell> <2640.1268899857@jrobl> <20100318175543.GA30924@shell>
Date: Fri, 19 Mar 2010 04:18:44 +0900
Message-ID: <14280.1268939924@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Valerie Aurora:
> Hm, I don't understand how handing it off to another thread would
> help.  The thing I am worried about is some internal assumption in the
> file system that a directory without write permission can't be
> changed.  Totally manufactured example:
>
> somefs_create()
> {
> 	BUG_ON(IS_RDONLY(dir->d_inode);
> [...]
> }

While I don't know whether there suce fs exists or not, for such fs we
cannot create files. I agree with you.


J. R. Okajima
