Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab2KEQxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:53:00 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42498 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab2KEQw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:52:58 -0500
MIME-Version: 1.0
In-Reply-To: <20121105081317.GC28886@opensource.wolfsonmicro.com>
References: <1349879449-22657-1-git-send-email-mporter@ti.com>
	<1BAFE6F6C881BF42822005164F1491C33EAB8596@DBDE01.ent.ti.com>
	<CAD=GYpZ9w=D55G9DOiMqZ4BCGGdGszsgG3fumHUGZ12xx+TKjw@mail.gmail.com>
	<1BAFE6F6C881BF42822005164F1491C33EAB973D@DBDE01.ent.ti.com>
	<CAD=GYpYuyfGuEgAWJyE2nkKx4GEsm=eDYAhV966sWVLbEPaqYQ@mail.gmail.com>
	<20121105081317.GC28886@opensource.wolfsonmicro.com>
Date: Mon, 5 Nov 2012 11:52:57 -0500
Message-ID: <CAD=GYpZ2BhXz4=0bG-ST06mbVxbmAZyzBTDz-MKcRBCb_cqKPw@mail.gmail.com>
Subject: Re: [PATCH] ARM: OMAP2+: AM33XX: clock data: fix mcasp entries
From: Joel A Fernandes <agnel.joel@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Porter, Matt" <mporter@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Nov 5, 2012 at 3:13 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Sat, Nov 03, 2012 at 02:32:59PM -0500, Joel A Fernandes wrote:
>
>> beaglebone_defconfig: Add dummy regulator to init tlv320aic3x
>> https://github.com/joelagnel/linux-kernel/commit/db5672dfe548d82625cf40ed688d05ba7cee5c93
>
> This should never be done in production, you should ensure that the
> appropriate supplies are provided by the board file or device tree.

Sure I just did this for debugging purpose,

Thanks,
Joel
