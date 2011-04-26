Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1DZJtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:49:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:45881 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab1DZJtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:49:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="684022566"
Date: Tue, 26 Apr 2011 11:49:08 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, a.zummo@towertech.it, johnpol@2ka.mipt.ru,
        cbou@mail.ru, dwmw2@infradead.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 07/14] mfd: fix build warning on 88pm860x
Message-ID: <20110426094907.GE2659@sortiz-mobl>
References: <2011041801>
 <1303135451-26362-8-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303135451-26362-8-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Mon, Apr 18, 2011 at 10:04:04PM +0800, Haojian Zhuang wrote:
> WARNING: vmlinux.o(.devinit.text+0x6c4): Section mismatch in reference
> from the function device_onkey_init() to the (unknown reference)
> .init.data:(unknown)
> The function __devinit device_onkey_init() references a (unknown reference)
>  __initdata (unknown).
> If (unknown) is only used by device_onkey_init then annotate (unknown)
> with a matching annotation.
> 
> It's caused by using __initdata on mfd cell resources. Replace __initdata
> with __devinitdata.
Patch applied, many thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
