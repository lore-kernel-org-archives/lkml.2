Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab1EZMp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:45:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49560 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516Ab1EZMp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:45:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: GuanXuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 4/6] unicore32: add KBUILD_DEFCONFIG with unicore32_defconfig (old debug_defconfig)
Date: Thu, 26 May 2011 14:45:50 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-28-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, greg@kroah.com
References: <cover.1306408804.git.gxt@mprc.pku.edu.cn> <3edfc75d669888b1732dbcdbecf73c6f7941c1a4.1306408804.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <3edfc75d669888b1732dbcdbecf73c6f7941c1a4.1306408804.git.gxt@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105261445.50905.arnd@arndb.de>
X-Provags-ID: V02:K0:xmEh2su9HhQ/GRDvl6cVeEhcjtQ+4zNLr4j6ePhY5eY
 tvA2DpBBMa9jCDzPKbI/EU7XUBfj+1sid5sfHEeIaGRvi95wMs
 pkERoSvHn7CC2mex4zvp0XLbmCCp2wR55dXzUna56PqMN1+xEB
 /uEkRGT973mYX68kK9FKANAM2uaAX7/H7eICm29nh2CDEdhMUI
 vUnj4rhPYXDX1oMkHjq7Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 May 2011, GuanXuetao wrote:
> From: Guan Xuetao <gxt@mprc.pku.edu.cn>
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> ---
>  arch/unicore32/Makefile                    |    3 +-
>  arch/unicore32/configs/debug_defconfig     |  215 ----------------------------
>  arch/unicore32/configs/unicore32_defconfig |  215 ++++++++++++++++++++++++++++
>  3 files changed, 217 insertions(+), 216 deletions(-)

Acked-by: Arnd Bergmann <arnd@arndb.de>

Remember to use '-M'
