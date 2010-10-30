Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab0J3Vkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:40:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54179 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0J3Vkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:40:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] PowerPC/Cell: use vzalloc rather than vmalloc and memset in spu_alloc_lscsa_std
Date: Sat, 30 Oct 2010 23:41:22 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org
References: <alpine.LNX.2.00.1010302004290.1572@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1010302004290.1572@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010302341.22738.arnd@arndb.de>
X-Provags-ID: V02:K0:7T7763G3deBAO5ETFbif7JGtvyHO2N4xI1EPJMjSgk7
 s5T0q5SXvs8dqMMGxlTzkYzaivOY06+YMyLraHp0Z+3B+zz/Gd
 oCz++grkaMUsfAXqJiBfSliX5/9nMA4PPBr2sVA26cezBA2b0e
 F7bMOGfpaDCfIbMO/hx4JM74wn3yZeyyBjMDO61ZfPqZ5NIM7a
 8eLpQMF6rqwJ4PFhA80ug==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 October 2010, Jesper Juhl wrote:
> We can get rid of a memset in 
> arch/powerpc/platforms/cell/spufs/lscsa_alloc.c::spu_alloc_lscsa_std() by 
> using vzalloc() rather than vmalloc()+memset().
> 
> Completely untested patch below since I have no hardware nor tools to 
> compile this.
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Arnd Bergmann <arnd@arndb.de>
