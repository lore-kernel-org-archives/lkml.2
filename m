Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab1AIASe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 19:18:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63946 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab1AIASd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 19:18:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
Subject: Re: [PATCH] asm-generic headers: add ftrace.h
Date: Sun, 9 Jan 2011 01:18:26 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <024001cbaf2c$cbe9cc70$63bd6550$@mprc.pku.edu.cn>
In-Reply-To: <024001cbaf2c$cbe9cc70$63bd6550$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101090118.26178.arnd@arndb.de>
X-Provags-ID: V02:K0:qs+ASRnHT3UUXpSSAacutf49JCUxQhKW0aotCZ42MMX
 eHb/hHOnDPtF39yBAf3YFUbFE0f2pG0XOcJk4o6G0MDCRiTHDZ
 GrFtkHRWZelffoII/BSE/mXqWZZWyzw2x6WKamDM/imexhbT/e
 i0YyV42UR9f1sek1Fu4C80nLPrUw3S+5uVfnAHpleFlE4dcNVX
 QlA2Plb9WvjO6H+ZN0eig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 January 2011, Guan Xuetao wrote:
> From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> 
>  This patch adds ftrace.h into asm-generic headers.
>  The file content could be empty in most architectures.
> 
> Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> ---
>  include/asm-generic/ftrace.h |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)

Acked-by: Arnd Bergmann <arnd@arndb.de>
