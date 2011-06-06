Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab1FFNah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:30:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55933 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab1FFNag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:30:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2] asm-generic: add another generic ext2 atomic bitops
Date: Mon, 6 Jun 2011 15:29:57 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andreas Dilger <adilger@dilger.ca>, linux-arch@vger.kernel.org
References: <1307201251-16805-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1307201251-16805-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106061529.57417.arnd@arndb.de>
X-Provags-ID: V02:K0:qDosqFTvGX9D81FJhJFHuaMN60pvrLipbh0HzONqDzm
 44VgHdB/skI5RReOQCJAu53OaU9XwkqxR1GNnHwoQ5jfM3mAnZ
 qhGRYDQabP7eA01P8js4/01y9+7VFkZCPVTuXTMwrEnl+oL9Fw
 CL49nQGLs7LxAStEDzr/ve+ikfL+e8vxgrWPx8lyS2rA1J90Cp
 B2mQf0FvcP7AyMp3OmcBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 June 2011, Akinobu Mita wrote:
> The majority of architectures implement ext2 atomic bitops as
> test_and_{set,clear}_bit() without spinlock.
> 
> This adds this type of generic implementation in ext2-atomic-setbit.h
> and use it wherever possible.
> 
> Suggested-by: Andreas Dilger <adilger@dilger.ca>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: linux-arch@vger.kernel.org

Looks good,

Acked-by: Arnd Bergmann <arnd@arndb.de>
