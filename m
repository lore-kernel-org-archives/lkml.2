Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab1DAJHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 05:07:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52485 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab1DAJHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 05:07:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH] unicore32 framebuffer fix: get videomemory by __get_free_pages() and make it floatable
Date: Fri, 1 Apr 2011 11:07:12 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "'Paul Mundt'" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
References: <003d01cbf046$f4947ca0$ddbd75e0$@mprc.pku.edu.cn>
In-Reply-To: <003d01cbf046$f4947ca0$ddbd75e0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104011107.12769.arnd@arndb.de>
X-Provags-ID: V02:K0:ssfITBxK5ABWQv+vBoHIvghjhB9+/h5EQfN296EyBdd
 Jh1eDkQ/QyfExw01BHW+c0IGnHBVIpJPa96RfMPpiaQUP3eYAF
 tVwin15pa8cmb/MIAjoI0A1OmZEn4G6grR6Z6NdExobB2ia2NU
 WbXUF2pRWs/xEqfzWawHHzdelrGamv1jhAa23yt2InqqJFrzg4
 Nu2kI9Egc/0KI7jDTjEjA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 April 2011, Guan Xuetao wrote:
> 1. get videomemory by __get_free_pages() in fb-puv3.c
> 2. remove resource reservation for old fixed UNIGFX_MMAP & UVC_MMAP space
> 3. remove unused macros: PKUNTIY_UNIGFX_MMAP_BASE, PKUNITY_UNIGFX_MMAP_SIZE,
>         PKUNITY_UVC_MMAP_BASE, PKUNITY_UVC_MMAP_SIZE and KUSER_UNIGFX_BASE
> 4. remove unused header linux/vmalloc.h in fb-puv3.h
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Acked-by: Arnd Bergmann <arnd@arndb.de>
