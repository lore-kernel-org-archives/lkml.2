Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab0H3Mpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:45:32 -0400
Received: from www.tglx.de ([62.245.132.106]:40217 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab0H3Mpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:45:31 -0400
Date: Mon, 30 Aug 2010 14:44:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
cc: Grant Likely <grant.likely@secretlab.ca>, meego-dev@meego.com,
        LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com, gregkh@suse.de,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
In-Reply-To: <001401cb4814$fb4bdd70$66f8800a@maildom.okisemi.com>
Message-ID: <alpine.LFD.2.00.1008301442290.9874@localhost6.localdomain6>
References: <4C77BD91.9070302@dsn.okisemi.com> <AANLkTikwZ1CHxup29nEPg9Jobz5B9SC5AftWorwWhUC9@mail.gmail.com> <alpine.LFD.2.00.1008272046410.2768@localhost.localdomain> <AANLkTimsPE2dpVdTNZXR-Yx0fX93Wk_vQDpFJc4xSaTX@mail.gmail.com>
 <001401cb4814$fb4bdd70$66f8800a@maildom.okisemi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010, Masayuki Ohtake wrote:
> > Indeed.  BTW, Ohtak-san, is this spi bus device something brand new,
> > or is it derived from an existing spi device?
> 
> Yes, Intel Topcliff is new concept device.

Thats right, but the question was whether the SPI peripheral is a new
IP design or similar to some already supported AMBA SPI peripheral.

Maybe the Intel folks can shed some light on that.

Thanks,

	tglx
