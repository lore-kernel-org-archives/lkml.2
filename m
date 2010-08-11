Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375Ab0HKRyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 13:54:47 -0400
Received: from vs244178.vserver.de ([62.75.244.178]:53234 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab0HKRyq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 13:54:46 -0400
Date: Wed, 11 Aug 2010 19:54:44 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <876929344.20100811195444@eikelenboom.it>
To: Joerg Roedel <joro@8bytes.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6.35] AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40  BUG: unable to handle kernel NULL pointer dereference at 0000000000000198
In-Reply-To: <20100810222419.GW23755@8bytes.org>
References: <1154489525.20100810164850@eikelenboom.it> <20100810162606.GQ23755@8bytes.org> <419601760.20100810185745@eikelenboom.it> <20100810180122.GR23755@8bytes.org> <1609756756.20100810200514@eikelenboom.it> <20100810202839.GS23755@8bytes.org> <618241473.20100810223635@eikelenboom.it> <20100810204721.GT23755@8bytes.org> <1498209076.20100810233659@eikelenboom.it> <20100810222419.GW23755@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joerg,

Had to apply the patch by hand, and found 2 typo's:

arch/x86/kernel/amd_iommu.c: In function âdo_attachâ:
arch/x86/kernel/amd_iommu.c:1456: error: implicit declaration of function âset_dte_enryâ
arch/x86/kernel/amd_iommu.c: In function âdo_detachâ:
arch/x86/kernel/amd_iommu.c:1486: error: implicit declaration of function âclear_dte_enryâ
make[2]: *** [arch/x86/kernel/amd_iommu.o] Error 1



Should be "entry" of course.

--

Sander
Wednesday, August 11, 2010, 12:24:19 AM, you wrote:

> On Tue, Aug 10, 2010 at 11:36:59PM +0200, Sander Eikelenboom wrote:
>> It boots now, dmesg attached.

> Ok, here is a quick and dirty patch wich should make your system boot
> again. It introduces other issues which will show up when you try to
> assign the devices to a virtual machine. But at least the devices should
> work again on bare-metal.

>         Joerg




-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it

