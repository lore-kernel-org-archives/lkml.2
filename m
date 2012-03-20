Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab2CTKP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 06:15:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab2CTKP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 06:15:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4F66F359.4060203@pku.edu.cn>
References: <4F66F359.4060203@pku.edu.cn> <1331868043.1971.10.camel@epip-laptop> <20120315205514.28759.58969.stgit@warthog.procyon.org.uk> <20120315205931.28759.81875.stgit@warthog.procyon.org.uk> <17897.1331889018@redhat.com>
To: gxt@mprc.pku.edu.cn
Cc: dhowells@redhat.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 27/38] Disintegrate asm/system.h for Unicore32 [ver #3]
Date: Tue, 20 Mar 2012 10:15:14 +0000
Message-ID: <28091.1332238514@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guan Xueao <gxt@pku.edu.cn> wrote:

> > Do the upstream binutils and gcc support unicore32 targets?
> >
> > David
> >
> Not yet. Sorry for the inconvenience.

Do you have patches I could apply to my cross-compiler RPMs?  I'm using
gcc-4.7 and binutils-2.22.52.0.1.  See:

	http://people.redhat.com/~dhowells/cross/

David
