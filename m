Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab2H1FqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 01:46:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57299 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab2H1FqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 01:46:17 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        Arnd Bergmann <arnd@arndb.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] lis3lv02d: Add STMicroelectronics lis331dlh digital
 accelerometer
Thread-Topic: [PATCH v2] lis3lv02d: Add STMicroelectronics lis331dlh digital
 accelerometer
Thread-Index: AQHNgC+0NDpTyonaHU+HVTncuJ8wyZdlGIEAgAmmkqA=
Date: Tue, 28 Aug 2012 05:45:46 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13EA20AD7@DBDE01.ent.ti.com>
References: <1345617039-27469-1-git-send-email-anilkumar@ti.com>
 <201208220748.39106.arnd@arndb.de>
In-Reply-To: <201208220748.39106.arnd@arndb.de>
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

Hi Eric,

On Wed, Aug 22, 2012 at 13:18:38, Arnd Bergmann wrote:
> On Wednesday 22 August 2012, AnilKumar Ch wrote:
> > This patch adds support for lis331dlh digital accelerometer to the
> > lis3lv02d driver family. Adds ID field for detecting the lis331dlh
> > module, based on this ID field lis3lv02d driver will export the
> > lis331dlh module functionality.
> > 
> > Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 

If there are no further comments could you please push
this patch?

Thanks
AnilKumar
