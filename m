Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab2FOIug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 04:50:36 -0400
Received: from relay.ihostexchange.net ([66.46.182.54]:42410 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab2FOIuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 04:50:32 -0400
From: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@ScaleMP.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ravikiran Thirumalai <kiran@ScaleMP.com>,
        "Ido Yariv (ido@wizery.com)" <ido@wizery.com>
Date: Fri, 15 Jun 2012 04:50:30 -0400
Subject: RE: linux-next: Tree for Jun 14 (vsmp)
Thread-Topic: linux-next: Tree for Jun 14 (vsmp)
Thread-Index: Ac1KdE2KTrZrMQ+mQQC5AMpznSUquAAX4ryg
Message-ID: <9B14D1490DDECA4E974F6B9FC9EBAB317EEFC75B73@VMBX108.ihostexchange.net>
References: <20120614162901.798d7661ea87e6134eee6f3a@canb.auug.org.au>
 <4FDA56D6.3000704@xenotime.net>
In-Reply-To: <4FDA56D6.3000704@xenotime.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5F8ogvC005604

Randy,

A fix for this was posted yesterday by Ido.


--Shai 


> -----Original Message-----
> From: Randy Dunlap [mailto:rdunlap@xenotime.net]
> Sent: Thursday, June 14, 2012 17:26
> To: Stephen Rothwell
> Cc: linux-next@vger.kernel.org; LKML; Ravikiran Thirumalai; Shai Fultheim
> (Shai@ScaleMP.com)
> Subject: Re: linux-next: Tree for Jun 14 (vsmp)
> 
> On 06/13/2012 11:29 PM, Stephen Rothwell wrote:
> 
> > Hi all,
> >
> > Changes since 20120613:
> 
> 
> 
> on x86_64:
> 
> arch/x86/built-in.o: In function `set_vsmp_pv_ops':
> vsmp_64.c:(.init.text+0x17155): undefined reference to `no_irq_affinity'
> 
> 
> Full randconfig file is attached.
> 
> --
> ~Randy
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
