Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab1BYQyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 11:54:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:59739 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab1BYQyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 11:54:53 -0500
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: David Woodhouse <dwmw2@infradead.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4D67C4A6.9050006@suse.com>
References: <4D671667.4000602@suse.com> <4D67378C.30506@msgid.tls.msk.ru>
	 <4D67C4A6.9050006@suse.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 16:54:49 +0000
Message-ID: <1298652889.22415.319.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-25 at 10:03 -0500, Jeff Mahoney wrote:
> 
> Because every time you run 'make modules_install', it overwrites
> whatever is in /lib/firmware when there is a collision. When you're
> working with multiple kernel versions, you can end up with firmware
> blobs from older builds, and that may not be what you want. If the
> right answer is to always use kernel-firmware, then the firmwares
> should probably not be in the kernel tree at all.

The right answer is to always use kernel-firmware. The firmwares should
not be in the kernel tree at all.

Changing the default behaviour of 'make modules_install' so that it no
longer installs firmware would be the better option. As a stop-gap until
we finally do drop the legacy firmware images from the source tree.

-- 
dwmw2

