Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab1KAPxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 11:53:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab1KAPxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 11:53:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20111023083636.GA14048@suse.de>
References: <20111023083636.GA14048@suse.de> <20111023062833.GA8126@kroah.com> <20111023062540.684446582@pistachio.kroah.org> <CA+55aFxkHr75LZU0udv=A+Bg52fMMOEfp47TTxHGbgf51UouRg@mail.gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, stable-review@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Kent <raven@themaw.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Chuck Ebbert <cebbert@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [22/27] VFS: Fix automount for negative autofs dentries
Date: Tue, 01 Nov 2011 15:51:21 +0000
Message-ID: <19544.1320162681@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> wrote:

> Ok, that makes a bit more sense, I'll add these if David and Miklos
> agree that they are ok to add here.  David and Miklos?

Sure.

David
