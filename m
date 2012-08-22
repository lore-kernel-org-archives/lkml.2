Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab2HVEZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 00:25:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49728 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab2HVEZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 00:25:32 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: RE: linux-next: Tree for July 17 (mfd/tps65217.c)
Thread-Topic: linux-next: Tree for July 17 (mfd/tps65217.c)
Thread-Index: AQHNf8Whfc8B1qO//0uyz4BDT8q5HpdlO4nw
Date: Wed, 22 Aug 2012 04:25:20 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13EA1B4EA@DBDE01.ent.ti.com>
References: <20120717154153.b10774cb005add05e4c4e5f6@canb.auug.org.au>
 <5005DDA7.6050401@xenotime.net> <501C0A21.2010905@xenotime.net>
 <331ABD5ECB02734CA317220B2BBEABC13EA0B471@DBDE01.ent.ti.com>
 <5033CAA9.9000101@xenotime.net>
In-Reply-To: <5033CAA9.9000101@xenotime.net>
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

Hi Samuel,

On Tue, Aug 21, 2012 at 23:21:37, Randy Dunlap wrote:
> On 08/05/2012 11:38 PM, AnilKumar, Chimata wrote:
> 
> > On Fri, Aug 03, 2012 at 22:58:01, Randy Dunlap wrote:
> >> On 07/17/2012 02:48 PM, Randy Dunlap wrote:
> >>
> >>> On 07/16/2012 10:41 PM, Stephen Rothwell wrote:
> >>>
> >>>> Hi all,
> >>>>
> >>>> Changes since 20120716:
> >>>>
> >>>
> >>>
> >>> on i386:
> >>>
> >>> drivers/built-in.o: In function `tps65217_probe':
> >>> tps65217.c:(.devinit.text+0x13e37): undefined reference to `of_regulator_match'
> >>>
> >>>
> >>> Full randconfig file is attached.
> >>> CONFIG_REGULATOR is not enabled.
> >>>
> >>
> >>
> >> This build error is still present in linux-next of 20120803.
> >>
> > 
> > This will be fixed with this patch
> > https://patchwork.kernel.org/patch/1220151/
> > 
> > Today, I will submit v2 for this
> 
> 
> This build still fails in linux-next 20120821.

Could you please push this patch ASAP?
http://www.spinics.net/lists/linux-omap/msg75336.html

Thanks
AnilKumar
