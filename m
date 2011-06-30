Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1F3MoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 08:44:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63433 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab1F3MoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 08:44:15 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: David Howells <dhowells@redhat.com>
Cc: Ric Wheeler <ricwheeler@gmail.com>, Michal Suchanek <hramrach@centrum.cz>,
        Alexander Viro <aviro@redhat.com>, Ian Kent <ikent@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: Union mount and overlayfs bake off?
References: <4E0AF2BA.2040706@gmail.com>
	<1302756608.2854.10.camel@perseus.themaw.net>
	<BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	<4DA4B6A8.7030804@gmail.com>
	<BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	<4DA5DCB8.3040101@gmail.com>
	<BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com>
	<4DA5F569.9020309@gmail.com>
	<BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com>
	<24792.1302808448@redhat.com> <2477.1309342656@redhat.com>
Date: Thu, 30 Jun 2011 14:44:59 +0200
In-Reply-To: <2477.1309342656@redhat.com> (David Howells's message of "Wed, 29
	Jun 2011 11:17:36 +0100")
Message-ID: <87vcvnpjxw.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> I've been dealing with some of Al's issues with the unionmount
> patches, but I know he's got more - I just can't remember them all.

A couple of questions I have:

1) What happens to the union in a cloned namespace (CLONE_NEWNS)?

2) What's the overhead for non-unioned filesystems if CONFIG_UNION_MOUNTS
is enabled?  Does it show up in any microbenchmarks?

3) Is there a future strategy for making atomic operations really atomic?
E.g. what happens if power is lost in the middle of a copy-up?  Or if
whiteout of source fails after a successful rename()?

4) Have you looked at overlayfs?  Do you have any thoughts about the
relative merrits of each solution?

Thanks,
Miklos
