Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab1GIMWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 08:22:21 -0400
Received: from mail06-md.ns.itscom.net ([175.177.155.116]:48082 "EHLO
	mail06-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab1GIMWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 08:22:20 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu
In-Reply-To: <8739ig3k93.fsf@tucsk.pomaz.szeredi.hu>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu> <20110608153208.dc705cda.akpm@linux-foundation.org> <20110609115934.3c53f78f@notabene.brown> <20110608205233.ebfedc4d.akpm@linux-foundation.org> <87wrgvb28a.fsf@tucsk.pomaz.szeredi.hu> <20110609123843.77153b27.akpm@linux-foundation.org> <877h8uzmsi.fsf@tucsk.pomaz.szeredi.hu> <21324.1307677721@jrobl> <871uyxa7ol.fsf@tucsk.pomaz.szeredi.hu> <8739ig3k93.fsf@tucsk.pomaz.szeredi.hu>
Date: Sat, 09 Jul 2011 21:22:15 +0900
Message-ID: <8536.1310214135@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos Szeredi:
> Here's a patch to document these limitations.

If you want covering limitations as possible, I'd suggest you to add
these.
- Some versions of GNU find(1) may produce a warning about the link
  count of a directory. When a sub dir exists, find(1) expects it
  increments the link count of the parent dir.
- If I remember correctly, Valerie Aurora has pointed out that
  open(O_RDONLY) + fchmod() will work correctly in UnionMount.
  It is true in overlayfs too?


J. R. Okajima
