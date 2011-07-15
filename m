Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab1GONEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 09:04:05 -0400
Received: from mail04-md.ns.itscom.net ([175.177.155.114]:56319 "EHLO
	mail04-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1GONEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 09:04:04 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu
In-Reply-To: <12864.1310734928@jrobl>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu> <20110608153208.dc705cda.akpm@linux-foundation.org> <20110609115934.3c53f78f@notabene.brown> <20110608205233.ebfedc4d.akpm@linux-foundation.org> <87wrgvb28a.fsf@tucsk.pomaz.szeredi.hu> <20110609123843.77153b27.akpm@linux-foundation.org> <877h8uzmsi.fsf@tucsk.pomaz.szeredi.hu> <21324.1307677721@jrobl> <871uyxa7ol.fsf@tucsk.pomaz.szeredi.hu> <8739ig3k93.fsf@tucsk.pomaz.szeredi.hu> <8536.1310214135@jrobl> <87k4bjd8pc.fsf@tucsk.pomaz.szeredi.hu> <12864.1310734928@jrobl>
Date: Fri, 15 Jul 2011 22:04:00 +0900
Message-ID: <12880.1310735040@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > st_nlink==1 for directories is widely accepted way of saying that the
> > number of subdirectories is unknown.  Various filesystems already do
> > this, and versions of GNU utils that I have come across accept it.
>
> When the upperdir is tmpfs, the link count of the directories in it will
> not be 1, won't it?

Ah, I've found overlayfs sets it to 1 now.

Thanks
J. R. Okajima
