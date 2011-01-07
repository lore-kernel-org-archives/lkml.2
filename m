Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1AGOK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:10:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59488 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab1AGOJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 09:09:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>,
        Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCHv1 11/12] unicore32 core architecture: signals
Date: Fri, 7 Jan 2011 01:16:57 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <00da01cba465$6d6e52f0$484af8d0$@mprc.pku.edu.cn>
In-Reply-To: <00da01cba465$6d6e52f0$484af8d0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
Message-Id: <201101070116.57654.arnd@arndb.de>
X-Provags-ID: V02:K0:DCngbGtF+VSfQepXhH22gwWJAYyqf5Yc/sH3UbmXqj6
 V63V9SoCdOtaVd/1+XHLve2YHPmvXE4KFXwFvBoPdVIYmgfbpA
 k/D1EiM7A3JiznnvrtT6yWtckVWe/pi3ExVsrqg/dr6zARbJhI
 C00I7xM1PRzP/Rp1nwj8GcGEb93nJpMherOo5XHH//OTMjdbnP
 bbi+cXJBxK3qGB/ppqaKQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 December 2010, Guan Xuetao wrote:
> From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> 
> Patch 11 implements signals.
> 
> Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> ---
>  arch/unicore32/include/asm/sigcontext.h |   61 ++++
>  arch/unicore32/kernel/signal.c          |  571 +++++++++++++++++++++++++++++++
>  arch/unicore32/kernel/signal.h          |   16 +
>  3 files changed, 648 insertions(+), 0 deletions(-)

Al Viro recently did a major cleanup of the signal handling code in a
number of architectures. He can probably give much better feedback
on this one than I can.

The one thing that sticks out to me is that you implement both legacy
and rt signals, where new architectures should generally only need the
rt variant.

	Arnd
