Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab1DZQr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:47:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:15810 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab1DZQr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:47:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,269,1301900400"; 
   d="scan'208";a="425798147"
Date: Tue, 26 Apr 2011 18:47:22 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, a.zummo@towertech.it, johnpol@2ka.mipt.ru,
        cbou@mail.ru, dwmw2@infradead.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 07/14] mfd: fix build warning on 88pm860x
Message-ID: <20110426164722.GI3175@sortiz-mobl>
References: <1303135451-26362-8-git-send-email-haojian.zhuang@marvell.com>
 <20110426094907.GE2659@sortiz-mobl>
 <BANLkTikX3g3+k3MPsps2N71iWsETqQXv3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikX3g3+k3MPsps2N71iWsETqQXv3Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Wed, Apr 27, 2011 at 12:44:23AM +0800, Haojian Zhuang wrote:
> On Tue, Apr 26, 2011 at 5:49 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > Hi Haojian,
> >
> > On Mon, Apr 18, 2011 at 10:04:04PM +0800, Haojian Zhuang wrote:
> >> WARNING: vmlinux.o(.devinit.text+0x6c4): Section mismatch in reference
> >> from the function device_onkey_init() to the (unknown reference)
> >> .init.data:(unknown)
> >> The function __devinit device_onkey_init() references a (unknown reference)
> >>  __initdata (unknown).
> >> If (unknown) is only used by device_onkey_init then annotate (unknown)
> >> with a matching annotation.
> >>
> >> It's caused by using __initdata on mfd cell resources. Replace __initdata
> >> with __devinitdata.
> > Patch applied, many thanks.
> >
> Thanks a lot. But I can't find it in your mfd tree. Could you update
> your tree? Since
> I need to rebase it and format new patches.
I just pushed to kernel.org. It's going to be there soon.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
