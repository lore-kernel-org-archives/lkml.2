Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab0E1ERG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 00:17:06 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:54055 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab0E1ERC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 00:17:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KKX/JezOdCP2tyFSB6XvZRhbPeU3wyGN20e7gzMj/Fptxp1obCc3BTEdo+kJ2Xidh7
         iDdHprThhZ7TTHA4/8NEyIqTUQHj86nDpCwNFvumdddgM4PL6N8cGW2OW17fWyv/DGAK
         LxkE0E4VZDERZLOt+wfLOTKEqwKLv9v301/o8=
Date: Fri, 28 May 2010 12:20:57 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: ranjith kumar <ranjithproxy@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: build error
Message-ID: <20100528042057.GC5257@cr0.nay.redhat.com>
References: <AANLkTim8vaJMBOoJeo74fTXWRV2l6JdyCWAOO2UeBFQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim8vaJMBOoJeo74fTXWRV2l6JdyCWAOO2UeBFQg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 02:54:38AM +0000, ranjith kumar wrote:
>hi
>On my PC "uname -a" prints
>Linux localhost.localdomain 2.6.29.4-167.fc11.i686.PAE #1 SMP Wed May
>27 17:28:22 EDT 2009 i686 i686 i386 GNU/Linux
>
>1)I tried to build many  linux kernel versions. But I always end up
>error lik "file not recognized: File truncated"
>
>For example when I tried to build linux-2.6.34(copied /boot/config
>file, make oldconfig, make all), I got the follwing error:
> CC [M]  drivers/mtd/ubi/eba.o
>  CC [M]  drivers/mtd/ubi/io.o
>  CC [M]  drivers/mtd/ubi/wl.o
>  CC [M]  drivers/mtd/ubi/scan.o
>  CC [M]  drivers/mtd/ubi/misc.o
>  LD [M]  drivers/mtd/ubi/ubi.o
>drivers/mtd/ubi/eba.o: file not recognized: File truncated
>make[3]: *** [drivers/mtd/ubi/ubi.o] Error 1
>make[2]: *** [drivers/mtd/ubi] Error 2
>make[1]: *** [drivers/mtd] Error 2
>make: *** [drivers] Error 2
>
>How to solve the problem?


Try to do a 'make mrproper' before compiling the kernel.


>2)And how to know processor family of my PC?


Your machine is x86_64, you could choose "Generic x86_64"
instead of these i386 stuffs. I think your distribution
also does this.

