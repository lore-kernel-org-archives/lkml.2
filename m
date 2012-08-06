Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2HFGiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 02:38:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52071 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab2HFGiT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 02:38:19 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: RE: linux-next: Tree for July 17 (mfd/tps65217.c)
Thread-Topic: linux-next: Tree for July 17 (mfd/tps65217.c)
Thread-Index: AQHNcZ2DyXSO/hqSt06yrRKjxx6GiZdMULAg
Date: Mon, 6 Aug 2012 06:38:10 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13EA0B471@DBDE01.ent.ti.com>
References: <20120717154153.b10774cb005add05e4c4e5f6@canb.auug.org.au>
 <5005DDA7.6050401@xenotime.net> <501C0A21.2010905@xenotime.net>
In-Reply-To: <501C0A21.2010905@xenotime.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.132.219]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 22:58:01, Randy Dunlap wrote:
> On 07/17/2012 02:48 PM, Randy Dunlap wrote:
> 
> > On 07/16/2012 10:41 PM, Stephen Rothwell wrote:
> > 
> >> Hi all,
> >>
> >> Changes since 20120716:
> >>
> > 
> > 
> > on i386:
> > 
> > drivers/built-in.o: In function `tps65217_probe':
> > tps65217.c:(.devinit.text+0x13e37): undefined reference to `of_regulator_match'
> > 
> > 
> > Full randconfig file is attached.
> > CONFIG_REGULATOR is not enabled.
> > 
> 
> 
> This build error is still present in linux-next of 20120803.
> 

This will be fixed with this patch
https://patchwork.kernel.org/patch/1220151/

Today, I will submit v2 for this

Regards
AnilKumar
