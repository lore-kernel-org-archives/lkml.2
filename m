Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab0HSCES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 22:04:18 -0400
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:40743 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab0HSCEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 22:04:16 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 14/38] fallthru: ext2 fallthru support
To: 7eggert@gmx.de
Cc: Miklos Szeredi <miklos@szeredi.hu>, jack@suse.cz, agruen@suse.de,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, linux-ext4@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
In-Reply-To: <E1OlrzM-0001lZ-0z@be1.7eggert.dyndns.org>
References: <eVJmW-3Lf-15@gated-at.bofh.it> <eVJmW-3Lf-19@gated-at.bofh.it> <fdNs6-5F1-7@gated-at.bofh.it> <fdVfY-pv-23@gated-at.bofh.it> <fe6Ep-cD-13@gated-at.bofh.it> <fiCPo-73x-17@gated-at.bofh.it> <fiMc1-6ip-7@gated-at.bofh.it> <E1OlrzM-0001lZ-0z@be1.7eggert.dyndns.org>
Date: Thu, 19 Aug 2010 11:03:20 +0900
Message-ID: <17214.1282183400@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bodo Eggert:
> Do a hardlink if you can create a hard link, otherwise use a fresh inode
> and use that for the next hardlink(s).

Exactly.
That's the approach aufs takes for whiteout and its brothers.


J. R. Okajima
