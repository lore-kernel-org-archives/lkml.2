Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab1BQR3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:29:39 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63903 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1BQR3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:29:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCHv2 08/11] unicore32 core architecture: mm related: consistent device DMA handling
Date: Thu, 17 Feb 2011 18:29:32 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Greg KH'" <greg@kroah.com>
References: <02f101cbcb48$a46271b0$ed275510$@mprc.pku.edu.cn>
In-Reply-To: <02f101cbcb48$a46271b0$ed275510$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171829.32157.arnd@arndb.de>
X-Provags-ID: V02:K0:jWWTU/sNR+unCKNTPmVbvkPEAzRjYeUaxmmBecHFYkr
 UKb09f+pgLhde3N2Ev9iKmIDgcwoizs22kF260ZYcOorxR0LcZ
 uCSH6vjpK7R4x0XSAQp6AKyJ5KNvGSc48iyGebFu9v+63y4bNX
 j1KEXK1ZIMI+XgabumV/vwHqO6Fy9uIqi7FtkSJ7DOdnn3l2YK
 1FdA6sKBSsd2yMtuTfjWg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 February 2011, Guan Xuetao wrote:
> 
> This patch implements consistent device DMA handling of memory management.
> DMA device operations are also here.
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
