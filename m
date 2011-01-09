Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab1AIASU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 19:18:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57274 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab1AIAST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 19:18:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
Subject: Re: [PATCH] asm-generic headers: add sizes.h
Date: Sun, 9 Jan 2011 01:18:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <023e01cbaf2c$5b8fbe80$12af3b80$@mprc.pku.edu.cn>
In-Reply-To: <023e01cbaf2c$5b8fbe80$12af3b80$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101090118.10420.arnd@arndb.de>
X-Provags-ID: V02:K0:KnPADvYCZVrmK4aCHxok+NjBqTeeMnwciIrMxOJ7gjd
 BN1PKIC6qX/DDYH70SexoGnsDBjyjnKc2h79R8ZghNpHlxDBR+
 NGpaXJQDjYk6QNu2BWeBJ8T4KKWTBJhbZq7S2/ZOZeL6myDNq9
 EvBNH1z4Dh4WDjumweMR/alfVpuo2PLsamro6yvmNb85g6FzOA
 4M3HRz70j51BwH7xcPwIA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 January 2011, Guan Xuetao wrote:
> From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> 
>  This patch adds sizes.h into asm-generic headers.
>  Only 32-bit version supported.
> 
> Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>


Looks good. I can take the patch into my asm-generic tree if you like, but
it's probably easier if you add it to your series as a prerequisite, because
you can avoid dependencies on my tree that way.

Same for the ftrace header.

Acked-by: Arnd Bergmann <arnd@arndb.de>
