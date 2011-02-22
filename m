Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1BVOUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:20:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62467 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1BVOUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:20:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 10/12] unicore32 machine related files: pci bus handling
Date: Tue, 22 Feb 2011 15:19:56 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Greg KH'" <greg@kroah.com>
References: <015501cbcdae$6961c5d0$3c255170$@mprc.pku.edu.cn> <201102171819.52845.arnd@arndb.de> <018801cbd29a$7400d800$5c028800$@mprc.pku.edu.cn>
In-Reply-To: <018801cbd29a$7400d800$5c028800$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102221519.56931.arnd@arndb.de>
X-Provags-ID: V02:K0:HifwCAa7AOWiSZ4Vh8kmSziYrFgHFQArNwaEMbTXo/T
 YzD1Wcg0nJTM5Y5HBYBII+KD0+LdMRFCJpW97w0vrLgA7rkSEU
 Bc/Omi/OT6M+Pk82Bjt2UCOujckX0OJvr/5D4MIGZuiur3/XFw
 S1cw9tDfnm2YZLJgcZXfvwEEnoaTOkEf8sYU+ICA7+xa9zcBx5
 Tjpem79FOKfWVeJnTvg8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 February 2011, Guan Xuetao wrote:
> Please see following patch:
> arch/unicore32/kernel/pci.c |   58 +++++++++++++++++++++---------------------
>  1 files changed, 29 insertions(+), 29 deletions(-)

Looks good to me.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
