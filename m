Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab2EYPUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:20:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177Ab2EYPUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:20:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87fwaoi9by.fsf@tucsk.pomaz.szeredi.hu>
References: <87fwaoi9by.fsf@tucsk.pomaz.szeredi.hu> <6422.1337872046@redhat.com> <1335357857-16416-1-git-send-email-miklos@szeredi.hu> <7204.1337874722@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 00/16] vfs: atomic open v4 (part 1)
Date: Fri, 25 May 2012 16:20:03 +0100
Message-ID: <13720.1337959203@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> > Also, does it make sense to combine:
> >
> > 	if (!S_ISREG(nd->inode->i_mode))
> > 		will_truncate = 0;
> >
> > with:
> >
> > 	int will_truncate = open_flag & O_TRUNC;
> >
> > up at the top of the function.
> 
> We need to check nd->inode->i_mode *after* the lookup.  So top of the
> function is not a good place.

Good point.

David
