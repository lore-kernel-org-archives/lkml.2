Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab0CRIMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 04:12:20 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:58585 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab0CRIME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 04:12:04 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [RFC PATCH] Show data flow for file copyup in unions
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Dmitry Monakhov <dmonakhov@openvz.org>,
       Jeff Layton <jlayton@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100318005358.GA24348@shell>
References: <20100316181711.GB24819@shell> <20335.1268779891@jrobl> <20100318005358.GA24348@shell>
Date: Thu, 18 Mar 2010 17:10:57 +0900
Message-ID: <2640.1268899857@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Valerie Aurora:
> I think what people will expect is that we copy up in that case.  I
> can think of ways this can go wrong, but perhaps that should be an
> explicit requirement on the top-layer file system, that it can handle
> create/unlink() in a directory without write permission.

I am not sure such requirement is the right way.
How about delegating open() to keventd or some other workqueue which
will succeed to create files under a directory without write permission?
Of course, we should handle some error cases after creating a file.


J. R. Okajima
