Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab1FBGAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 02:00:22 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37297 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab1FBGAV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 02:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hEs2Pq62mSosADXmhIZjudKSSBY7a+jtGKojFgdZOblEMt8B57PfVi9wYIdu5N+xei
         8h9canaGLzbvoxleUxsPznRGIbY/20Mcf6ssTiC/fg0fGnuX9Gum7dLLIp/8KQPqo+lX
         077zWMK+H0Sp4R5fZn+jb7jrORpQca7xKOFw8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1106011712270.21697@trent.utfs.org>
References: <alpine.DEB.2.01.1105311644010.21697@trent.utfs.org>
	<alpine.DEB.2.01.1106011712270.21697@trent.utfs.org>
Date: Thu, 2 Jun 2011 08:00:19 +0200
Message-ID: <BANLkTi=ceV9Xs0hpaAufE_+W1RPHyMCBow@mail.gmail.com>
Subject: Re: 3.0-rc1: powerpc hangs at Kernel virtual memory layout
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>, linville@tuxdriver.com,
        benh@kernel.crashing.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/2 Christian Kujau <lists@nerdbynature.de>:
> On Tue, 31 May 2011 at 16:50, Christian Kujau wrote:
>> trying to boot 3.0-rc1 on powerpc32 only progresses until:
>>
>>   > Kernel virtual memory layout:
>>   >   * 0xfffcf000..0xfffff000  : fixmap
>
> After hours (and hours!) of git-bisecting, it said:
>
> -----------------------
> ccc7c28af205888798b51b6cbc0b557ac1170a49 is the first bad commit
> commit ccc7c28af205888798b51b6cbc0b557ac1170a49
> Author: Rafał Miłecki <zajec5@gmail.com>
> Date:   Fri Apr 1 13:26:52 2011 +0200
>
>    ssb: pci: implement serdes workaround
>
>    Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
> -----------------------

I'm for the problem :(

Patch was already send yesterday, I've even CCed linuxppc-dev:
[RFT][PATCH 3.0] ssb: fix PCI(e) driver regression causing oops on PCI cards

-- 
Rafał
