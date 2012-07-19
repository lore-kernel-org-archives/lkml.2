Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab2GSSUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 14:20:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39747 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2GSSUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 14:20:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120719192814.75ea8beb784bdf8bb32c510c@kinali.ch>
References: <20120719192814.75ea8beb784bdf8bb32c510c@kinali.ch>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 19 Jul 2012 12:19:48 -0600
X-Google-Sender-Auth: P_s1kD1Ezcm4Xwzh5JgpWVLKZOU
Message-ID: <CACxGe6tUOAtRgV9NHgfLchFAmQH99g0jNh0ANxyKPasbkHn2Kg@mail.gmail.com>
Subject: Re: commit 91013923c712e1c: "irqdomain: Replace LEGACY mapping with
 LINEAR" breaks console on ARM i.mx23
To: Attila Kinali <attila@kinali.ch>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Linux ARM kernel <linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 11:28 AM, Attila Kinali <attila@kinali.ch> wrote:
> Hi,
>
> I'm working on an embedded system based on a Freescale ARM9 processor i.mx23.
>
> While trying linux-next i stumpled over my login prompt getting broken.
> What exactly happens is that the kernel boots normally, but when my
> login prompt should appear it suddenly stops. I bisected it back to
> the commit 91013923c712e1c4b9b343f0ee4a86ce72b1b630
> irqdomain: Replace LEGACY mapping with LINEAR
>
> Reverting this and the three commits that directly depend on it (see below)
> everything seems to work fine again

Mark Brown also noticed this and pointed this out. I'm working on it.
I've pulled those three patches out of my -next branch while I'm
working on the fix.

g.
