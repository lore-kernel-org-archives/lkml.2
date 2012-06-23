Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab2FWVLe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:11:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50298 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab2FWVLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:11:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Cong Wang <amwang@redhat.com>
Subject: Re: [PATCH 00/12] kmap_atomic cleanup for 3.6
Date: Sat, 23 Jun 2012 21:11:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
In-Reply-To: <1340445863-16111-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206232111.25411.arnd@arndb.de>
X-Provags-ID: V02:K0:FKuxp5DReIAdSfsxwoczTcbXflXqw0yiZTD+SurYZuB
 P/ZrVMkpA3ZTOPjR5V5aKgcrP4J1x8R0yPijKzQZWZmbzgm5/K
 yzpioNBxdk0p2C1grh6Y+PaPgR426C9XOPbdODvRG4VYAbP26y
 VTdlxgAccbYUNcZDHvE5R92itlDr7fXiPeIqViSXxD1nUPLoT1
 QRBb3dRuR+VJ4PLEttZjajK/hpp4BsmLslWA+71SI3tMymupyc
 /RmL2tLxwJraDqUVZMosGuexIJNFKAPBITQFhChPCQPFVOcmWb
 eJRB4vvOvuunLEXQCS0QVEgfqRno//wZVIaX9k/Bbme5pTsgBh
 gJI14kelCFQr7MWX/oPU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 June 2012, Cong Wang wrote:
> After few releases, it seems there are no more callers
> using the deprecated form of kmap_atomic(), the one
> with two parameters. So we can remove it now and remove
> the KM_* definition except KM_TYPE_NR together.
> 
> All the patches are available at:
> 
>         git://github.com/congwang/linux.git #kmap_atomic
> 

What is the significance of having an architecture-specific
definition for KM_TYPE_NR now? Should that be replaced
with a fixed value in include/linux/highmem.h so we can
remove the asm/kmap_types.h files entirely?

	Arnd
