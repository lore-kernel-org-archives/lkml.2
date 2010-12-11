Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab0LKUa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 15:30:26 -0500
Received: from beauty.rexursive.com ([150.101.121.179]:42505 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab0LKUaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 15:30:24 -0500
Subject: Re: [linux-pm] [PATCH] PM / Hibernate: Restore old swap signature
 to avoid user space breakage
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Karel Zak <kzak@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <linux@treblig.org>
In-Reply-To: <201012112058.09689.rjw@sisk.pl>
References: <201012052324.30231.rjw@sisk.pl>
	 <1291592215.2866.3.camel@shrek.rexursive.com>
	 <201012112058.09689.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Dec 2010 07:30:20 +1100
Message-ID: <1292099420.1630.3.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-12-11 at 20:58 +0100, Rafael J. Wysocki wrote:
> I'm afraid I'll have to push this patch to Linus.  Turns out that
> Fedora 14 doesn't pass the resume= argument to the kernel and tries to
> trigger the resume from initramfs.  Since the signature changed, it
> can't find the image and the resume fails, even if both the resume and
> image kernels are the same. 

Why don't you just file a Fedora bug asking for the library to be
upgraded or patched?

PS. Karel, who also replied to this thread, has a Red Hat address and he
seems to be the maintainer of util-linux-ng package. He should be able
to fix this.

-- 
Bojan

