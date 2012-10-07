Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab2JGMOH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 08:14:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:48019 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab2JGMN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 08:13:56 -0400
Date: Sun, 7 Oct 2012 09:13:28 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: trivial@vger.kernel.org, crope@iki.fi, gennarone@gmail.com,
        dan.carpenter@oracle.com, hans.verkuil@cisco.com, thomas@m3y3r.de,
        santoshprasadnayak@gmail.com, abraham.manu@gmail.com,
        stoth@kernellabs.com, dheitmueller@kernellabs.com,
        t.stanislaws@samsung.com, liplianin@netup.ru,
        andriy.shevchenko@linux.intel.com, ptqa@netup.ru, David@Fries.net,
        thunder.mmm@gmail.com, j@jannau.net, s.nawrocki@samsung.com,
        sungchun.kang@samsung.com, khw0178.kim@samsung.com,
        shaik.ameer@samsung.com, hdegoede@redhat.com, tobias.lorenz@gmx.net,
        gregkh@suse.de, paul.gortmaker@windriver.com, m@bues.ch,
        hfvogt@gmx.net, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] drivers/media: Remove unnecessary semicolon
Message-ID: <20121007091328.21c59e5f@infradead.org>
In-Reply-To: <1348746906-26863-1-git-send-email-peter.senna@gmail.com>
References: <1348746906-26863-1-git-send-email-peter.senna@gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Em Thu, 27 Sep 2012 13:55:06 +0200
Peter Senna Tschudin <peter.senna@gmail.com> escreveu:

> Remove unnecessary semicolon
> 
> And:
> drivers/media/dvb-frontends/stv0900_core.c: remove unnecessary whitespace before a
> quoted newline

(answering about your v3 here, instead of at your v3 email as it got
 lost - I had subscribed from vger - you likely sent the patch during
 that period of time - fortunately, patchwork got it)

This patch doesn't apply as-is:

Applying patch patches/lmml_14721_v3_drivers_media_remove_unnecessary_semicolon.patch
patching file drivers/media/dvb-core/dvb_frontend.c
Hunk #1 succeeded at 2309 (offset 21 lines).
patching file drivers/media/dvb-frontends/a8293.c
patching file drivers/media/dvb-frontends/af9013.c
patching file drivers/media/dvb-frontends/bcm3510.c
patching file drivers/media/dvb-frontends/cx24110.c
patching file drivers/media/dvb-frontends/drxd_hard.c
patching file drivers/media/dvb-frontends/isl6405.c
patching file drivers/media/dvb-frontends/isl6421.c
patching file drivers/media/dvb-frontends/itd1000.c
Hunk #1 FAILED at 231.
1 out of 1 hunk FAILED -- rejects in file drivers/media/dvb-frontends/itd1000.c
patching file drivers/media/dvb-frontends/lnbp21.c
patching file drivers/media/dvb-frontends/lnbp22.c
patching file drivers/media/dvb-frontends/si21xx.c
patching file drivers/media/dvb-frontends/sp8870.c
Hunk #1 FAILED at 188.
Hunk #2 FAILED at 207.
Hunk #3 FAILED at 229.
3 out of 3 hunks FAILED -- rejects in file drivers/media/dvb-frontends/sp8870.c
patching file drivers/media/dvb-frontends/sp887x.c
patching file drivers/media/dvb-frontends/stv0299.c
patching file drivers/media/dvb-frontends/stv0900_core.c
patching file drivers/media/dvb-frontends/tda8083.c
patching file drivers/media/i2c/cx25840/cx25840-core.c
patching file drivers/media/pci/bt8xx/dst_ca.c
patching file drivers/media/pci/cx23885/altera-ci.c
patching file drivers/media/pci/cx23885/cimax2.c
patching file drivers/media/pci/cx88/cx88-blackbird.c
Hunk #1 FAILED at 721.
Hunk #2 FAILED at 739.
Hunk #3 FAILED at 755.
3 out of 3 hunks FAILED -- rejects in file drivers/media/pci/cx88/cx88-blackbird.c
patching file drivers/media/pci/cx88/cx88-dvb.c
patching file drivers/media/pci/cx88/cx88-mpeg.c
patching file drivers/media/pci/cx88/cx88-tvaudio.c
patching file drivers/media/pci/cx88/cx88-video.c
patching file drivers/media/pci/saa7134/saa7134-video.c
patching file drivers/media/platform/exynos-gsc/gsc-regs.c
patching file drivers/media/radio/si470x/radio-si470x-i2c.c
Hunk #1 succeeded at 308 (offset 11 lines).
patching file drivers/media/radio/si470x/radio-si470x-usb.c
patching file drivers/media/radio/si4713-i2c.c
Hunk #1 FAILED at 1009.
Hunk #2 FAILED at 1081.
Hunk #3 FAILED at 1130.
Hunk #4 FAILED at 1420.
Hunk #5 FAILED at 1473.
Hunk #6 FAILED at 1698.
6 out of 6 hunks FAILED -- rejects in file drivers/media/radio/si4713-i2c.c
patching file drivers/media/usb/dvb-usb-v2/af9015.c
patching file drivers/media/usb/dvb-usb-v2/af9035.c
Hunk #1 succeeded at 520 (offset 1 line).

As this patch is trivial enough, I'll just discard the affected hunks
with "quilt push -f", applying it partially.

Cheers,
Mauro
