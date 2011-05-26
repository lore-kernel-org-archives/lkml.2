Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab1EZMpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:45:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49924 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500Ab1EZMpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:45:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: GuanXuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 6/6] unicore32: using generic-y format for one line asm-generic files
Date: Thu, 26 May 2011 14:45:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-28-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, greg@kroah.com,
        Sam Ravnborg <sam@ravnborg.org>
References: <cover.1306408804.git.gxt@mprc.pku.edu.cn> <48ec206f634cad2019c92eef7ba1a87566c743fe.1306408804.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <48ec206f634cad2019c92eef7ba1a87566c743fe.1306408804.git.gxt@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105261445.01390.arnd@arndb.de>
X-Provags-ID: V02:K0:OSMGJMXE1Io5828YNSD95ZpRYOQg5zNyz0LGcD1bbAp
 s5qkx9O0r2Uim/dwglJK6+xlmbT0gwleq4Or3WQoUdHzQuduUS
 P1Trs4vHNeTv6EBrsu9gJNw5F4IEddbrG/5JpptJ52YEFZVkZE
 usNd3sNX6CbZkxhJ3GtlxxO3nmnGXMET2RkE3Szd/0Wcf5a1yz
 LKawtPIJbM/znn09APVVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 May 2011, GuanXuetao wrote:
> From: Guan Xuetao <gxt@mprc.pku.edu.cn>
> 
> see commit from Sam Ravnborg <d8ecc5cd8e227bc318513b5306ae88a474b8886d>
>   kbuild: asm-generic support
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> ---
>  arch/unicore32/Makefile           |   35 ----------------------
>  arch/unicore32/include/asm/Kbuild |   59 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+), 35 deletions(-)

Acked-by: Arnd Bergmann <arnd@arndb.de>

This reminds me that I should do the same for ARM and maybe some others.
