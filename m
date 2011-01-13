Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab1AMOLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:11:51 -0500
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:55228 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876Ab1AMOLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:11:46 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH] fs: Work around NFS wreckage
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Nick Piggin <npiggin@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        "Ramirez Luna, Omar" <omar.ramirez@ti.com>
In-Reply-To: <alpine.LFD.2.00.1101131436070.2678@localhost6.localdomain6>
References: <alpine.LFD.2.00.1101131436070.2678@localhost6.localdomain6>
Date: Thu, 13 Jan 2011 23:10:45 +0900
Message-ID: <8952.1294927845@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thomas Gleixner:
> The dcache scalability work broke NFS root filesystems.
	:::
> Check for parent equal dentry and skip the nested lock to avoid the
> deadlock. I'm sure this is the wrong fix, but at least it "works" :)

With this patch, can you unmount it cleanly?
It skips incrementing d_count for both dentries.
Do we need at least one?


J. R. Okajima
