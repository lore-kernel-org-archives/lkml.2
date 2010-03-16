Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab0CPWwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 18:52:19 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:63195 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab0CPWwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 18:52:18 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [RFC PATCH] Show data flow for file copyup in unions
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Dmitry Monakhov <dmonakhov@openvz.org>,
       Jeff Layton <jlayton@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100316181711.GB24819@shell>
References: <20100316181711.GB24819@shell>
Date: Wed, 17 Mar 2010 07:51:31 +0900
Message-ID: <20335.1268779891@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Valerie Aurora:
> 1. Don't copyup if the operation would fail (e.g., open(O_WRONLY) on a
> file with mode 444).  It's inefficient and a possible security hole to
> copy up a file if no write (or maybe even read) can occur anyway.

Just a question.
How about this case?
When the file is writable (0644 or something) but its parent directory
is readonly (0555), do you think the file should be copied-up?


J. R. Okajima
