Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab2APPuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 10:50:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203Ab2APPuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 10:50:18 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <19981.1325887323@redhat.com>
References: <19981.1325887323@redhat.com>
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, arnd@arndb.de, alan@lxorguk.ukuu.org.uk,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, airlied@redhat.com
Subject: Pulling the rest of the User-API header split patches
Date: Mon, 16 Jan 2012 15:50:02 +0000
Message-ID: <10234.1326729002@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Thanks for pulling the User-API header split preliminary patches.

Will you be pulling the rest of the patches to actually perform the split at
the end of this merge window?  If so, as previously mentioned, I'll need to
regenerate them before you do.

However, for the moment, I dropped the preliminary patches from my tree and
regenerated the rest based on the tree I saw this morning:

http://git.infradead.org/users/dhowells/linux-headers.git/shortlog/refs/heads/uapi-split

I've made 'make allyesconfig' build again on x86_64.  arch/x86/lib/insn.c is
compiled for use in both userspace and kernelspace, necessitating a bit of
#include adjustment, but that was the only necessary change.  I've also had
Dave Airlie review the preparatory DRM patches and those have been adjusted.

An opinion, if I may: I have been checking the scripts into the GIT tree (with
the intention to delete them later) so that a record of them is retained - but
I wonder if I should bother...  Hopefully, once the scripts are run and the
results applied, it won't be necessary to retain the scripts.

Thanks,
David
