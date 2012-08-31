Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab2HaMr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 08:47:59 -0400
Received: from mail02-md.ns.itscom.net ([175.177.155.112]:57934 "EHLO
	mail02-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab2HaMr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 08:47:57 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 05/13] overlayfs: add statfs support
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com, dhowells@redhat.com,
        hpj@urpla.net, sedat.dilek@googlemail.com, penberg@kernel.org,
        goran.cetusic@gmail.com, romain@orebokech.com
In-Reply-To: <1346306092.17040.3.camel@deadeye.wl.decadent.org.uk>
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu> <1345045700-9062-6-git-send-email-miklos@szeredi.hu> <20120817182051.GC29217@decadent.org.uk> <87d32971s3.fsf@tucsk.pomaz.szeredi.hu> <1346306092.17040.3.camel@deadeye.wl.decadent.org.uk>
Date: Fri, 31 Aug 2012 21:47:53 +0900
Message-ID: <7965.1346417273@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ben Hutchings:
> If I'm not mistaken, glibc uses it to implement pathconf(_PC_NAME_MAX),
> which may be used by applications in conjunction with readdir_r().

I agree pathconf(3) depends upon the filesystem type. I've posted about
the _PC_LINK_MAX and statfs(2). See my past post and its thread in detail.

[RFC 0/5] pathconf(3) with _PC_LINK_MAX
<http://marc.info/?l=linux-kernel&m=126008634810706&w=2>


J. R. Okajima

