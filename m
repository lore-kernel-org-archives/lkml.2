Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab1GONdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 09:33:38 -0400
Received: from mail06-md.ns.itscom.net ([175.177.155.116]:37685 "EHLO
	mail06-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1GONdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 09:33:37 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu
In-Reply-To: <87fwm7d74s.fsf@tucsk.pomaz.szeredi.hu>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu> <20110608153208.dc705cda.akpm@linux-foundation.org> <20110609115934.3c53f78f@notabene.brown> <20110608205233.ebfedc4d.akpm@linux-foundation.org> <87wrgvb28a.fsf@tucsk.pomaz.szeredi.hu> <20110609123843.77153b27.akpm@linux-foundation.org> <877h8uzmsi.fsf@tucsk.pomaz.szeredi.hu> <21324.1307677721@jrobl> <871uyxa7ol.fsf@tucsk.pomaz.szeredi.hu> <8739ig3k93.fsf@tucsk.pomaz.szeredi.hu> <8536.1310214135@jrobl> <87k4bjd8pc.fsf@tucsk.pomaz.szeredi.hu> <12864.1310734928@jrobl> <87fwm7d74s.fsf@tucsk.pomaz.szeredi.hu>
Date: Fri, 15 Jul 2011 22:33:34 +0900
Message-ID: <13585.1310736814@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos Szeredi:
> Overlayfs will create a private clone of both the lower and upper
> mounts.  The mnt_flags are only modified on the private clone, whose
> sole user is overlayfs itself.

Yes, I've found overlayfs creates private clone mounts. Sorry noise
again.
By cloning privately, users cannot change mount flags. But it will not
be a big problem.

By the way, you might remember that I have asked about overriding
creditials and signals.
When a process issues chmod, rename or something, then the internal
copyup happens. If RLIMIT_FSIZE is set to the process, then it may
fire SIGXFSZ and return EFBIG. It looks strange. But I don't know how
important is it since setting RLIMIT_FSIZE is less popular I am afraid.


J. R. Okajima
