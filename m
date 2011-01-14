Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab1ANAE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 19:04:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab1ANAEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 19:04:22 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.2.00.1101140847200.27060@tundra.namei.org>
References: <alpine.LRH.2.00.1101140847200.27060@tundra.namei.org> <20101224144834.22524.86008.stgit@warthog.procyon.org.uk>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        tomoyo-users-en@lists.sourceforge.jp,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] CacheFiles: Add calls to path-based security hooks [ver #2]
Date: Fri, 14 Jan 2011 00:03:54 +0000
Message-ID: <22056.1294963434@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> > Add calls to path-based security hooks into CacheFiles as, unlike
> > inode-based security, these aren't implicit in the vfs_mkdir() and similar
> > calls.
> 
> Adding fsdevel for further review - cachefiles is essentially part of the 
> vfs, right ?

It certainly makes good use of the VFS interfaces, so I suppose in that sense,
yes.

David
