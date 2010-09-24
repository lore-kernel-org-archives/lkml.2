Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab0IXUkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 16:40:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:65103 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab0IXUkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 16:40:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vernon Mauery <vernux@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode driver -v4
Date: Fri, 24 Sep 2010 22:40:38 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>
References: <20100921224610.GO13162@lucy> <201009241940.18931.arnd@arndb.de> <20100924182327.GC10777@lucy>
In-Reply-To: <20100924182327.GC10777@lucy>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009242240.38987.arnd@arndb.de>
X-Provags-ID: V02:K0:dY0IBp+aO5/Pq1/rLOevYs8lFzFpjhWRamres7KP+hb
 vckS6sM1vZML+6Tz+mKPu3dDfmmj2pxBwgi8zfk/pRxTwjttmB
 MXFxX3jcN52cgZukGzumcL4933UDgS1Aco5GPpmFi1E5n9uZ24
 Rm9QzPwJcTFKKK0c/2PJkNrNB0beL1ZT/VLzDMDvbg7JeeDO2l
 VwnsBmvGom4vZ0pfvrIMQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 September 2010 20:23:27 Vernon Mauery wrote:
> No, inb/outb have address as as unsigned long, which would explain why 
> 0x40000 works with PIO.  When doing inb/outb via the ioread/iowrite 
> macros, the port value is the address (minus the offset) masked off to 
> PIO_MASK, which is 16 bits on x86.

What I meant is that the inb/outb *instructions* only take a 16 bit
argument, not the kernel functions. You should really try to find
out what is going on there.

	Arnd
