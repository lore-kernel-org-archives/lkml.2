Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab1CSUr1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 16:47:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53810 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757469Ab1CSUrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 16:47:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] asm-generic: support clock_adjtime() in <asm-generic/unistd.h>
Date: Sat, 19 Mar 2011 21:47:20 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
References: <201103191554.p2JFsQ9N010993@farm-0023.internal.tilera.com>
In-Reply-To: <201103191554.p2JFsQ9N010993@farm-0023.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103192147.20632.arnd@arndb.de>
X-Provags-ID: V02:K0:THwNF8g7uSbgQFps+YeaYcoptdHPbvepVZ/4KGq54im
 AREpjO0eJKU4mgcaJEUgiWjvOGvsM/m6AGNbIqOOb009L2lvyg
 uBAYfWJzw1aY27xr0/orQQyyruo0dx25GMhLP/eWAqPVLSW6bN
 XHGwNpURN3vf1/GhpwSpk0bPqToqUzYOALj0ypMNKC52qN57KF
 s3MagAWZuE4ZaIiEHjDaA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 March 2011 16:47:53 Chris Metcalf wrote:
> 
> A syscall was added without being added to asm-generic, which
> makes tile (and presumably score and unicore32) break.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Cc: Chen Liqin <liqin.chen@sunplusct.com>
> Cc: Lennox Wu <lennox.wu@gmail.com>

I don't consider it actually broken, but your patch
is definitely needed to support the new syscall, and
looks totally correct.

Acked-by: Arnd Bergmann <arnd@arndb.de>

I don't have any other changes queued up for asm-generic
in this release, so please just merge it through your
tree if you like.

	Arnd
