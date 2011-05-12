Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183Ab1ELRWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:22:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758108Ab1ELRWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:22:10 -0400
MIME-Version: 1.0
In-Reply-To: <1305217732.15566.31.camel@lade.trondhjem.org>
References: <87fwokarjj.fsf@tucsk.pomaz.szeredi.hu> <BANLkTin6Ujea+qdkvwkH_9o5F8WKPyFdyA@mail.gmail.com>
 <BANLkTi=4rdtB5dQH=tycT1sybe7iJmTVcA@mail.gmail.com> <1305217732.15566.31.camel@lade.trondhjem.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 May 2011 10:21:21 -0700
Message-ID: <BANLkTikBVAJSmBZrAvJ6fRQD32TFNeO4zQ@mail.gmail.com>
Subject: Re: [GIT PULL] fuse fix for 2.6.39
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 9:28 AM, Trond Myklebust
<Trond.Myklebust@netapp.com> wrote:
>
> NFS also requires look up using the full 'struct path' if/when we happen
> upon an automount point (i.e. if we cross into a submounted filesystem
> on the server or if we encounter an NFSv4 referral). Again, this is
> something that lookup_one_len() can't do.

Sure. But we might not want to oops. Would you be willing to try
ecryptfs over NFS to at least make it limp along?

                       Linus
