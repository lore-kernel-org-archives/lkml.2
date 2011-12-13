Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1LMN6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 08:58:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab1LMN6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 08:58:19 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <11863.1323784204@redhat.com>
References: <11863.1323784204@redhat.com> <20111213235714.8e1c456786e60acc691b899e@canb.auug.org.au> <1323770653-19177-1-git-send-email-dhowells@redhat.com> <1323770653-19177-15-git-send-email-dhowells@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, arnd@arndb.de,
        alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 14/17] UAPI: Make linux/patchkey.h easier to parse
Date: Tue, 13 Dec 2011 13:57:57 +0000
Message-ID: <12078.1323784677@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > Is this part missing, or no longer needed?
> 
> It seems to have got lost somewhere.  Thanks for catching it.

Actually, it doesn't seem to be necessary.  The header splitter managed to cope
without it and did the right thing.  I think what happened was that the
splitter didn't recognise the _LINUX_PATCHKEY_H_INDIRECT thing as a reinclusion
guard, so it just tossed that into the UAPI header, then recognised the
_LINUX_PATCHKEY_H thing as the reinclusion guard and proceeded from there.

Would you prefer that I remove that from the comments or would you prefer that
I leave things unchanged?

David
