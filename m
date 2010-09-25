Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab0IYP4K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 11:56:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55911 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab0IYP4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 11:56:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] autofs: Only declare function when CONFIG_COMPAT is defined
Date: Sat, 25 Sep 2010 17:55:57 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3+; KDE/4.5.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?utf-8?q?M=C3=A1rton_N=C3=A9meth?= <nm127@freemail.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Ian Kent <raven@themaw.net>
References: <1285334543-7074-1-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1285334543-7074-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201009251755.57690.arnd@arndb.de>
X-Provags-ID: V02:K0:nmMWXOHLXktu5AslW07njsFcEyifMRiPbO8yr9qVFKq
 Xye8cr8e+DPyGdnhZoX4IKw+vHAifwf+j7vvGPv4i1q3whRtDw
 HFZBlUhmN08ujJu76hz0MPrtcpkpEWTiyE4gP9HQ+2HfNT6lOq
 LZQcqAjr5w/3LvvCjyRwpMoSYG0IoMYKq/65E/cv7uPIKkMbz+
 ZNiFQitt58uT6ZSfbD/ew==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 September 2010 15:22:22 Frederic Weisbecker wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The patch solves the following warnings message when CONFIG_COMPAT
> is not defined:
> 
> fs/autofs/root.c:30: warning: ‘autofs_root_compat_ioctl’ declared ‘static’ but never defined
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

My initial reaction was to put these into my bkl/vfs tree, but then I noticed
that they are against a 2.6.36 bug. Who's taking care of getting them upstream?

- Ian (maintainer)
- Arnd (who wrote the broken patch to start with)
- Frederic (who pushed the broken patch to Linus)
- Andrew (took them into -mm)

I don't care either way, just trying to make sure it gets there and we don't
all submit the same patch simultaneously.

The current state is annoying but harmless, so I could also just add the
patches to my 2.6.37 queue, which already has autofs patches for the BKL.

	Arnd
