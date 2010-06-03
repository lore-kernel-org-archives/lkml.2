Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab0FCMuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:50:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54969 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab0FCMuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:50:13 -0400
Subject: Re: [alsa-devel] [RFC][PATCH 20/26] alsa: ASoC: Add JZ4740 codec
 driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       alsa-devel@alsa-project.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1275568334.3593.92.camel@odin>
References: <1275505397-16758-1-git-send-email-lars@metafoo.de>
	 <1275505950-17334-4-git-send-email-lars@metafoo.de>
	 <1275568334.3593.92.camel@odin>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 13:50:08 +0100
Message-ID: <1275569408.3593.107.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 13:32 +0100, Liam Girdwood wrote:
> On Wed, 2010-06-02 at 21:12 +0200, Lars-Peter Clausen wrote:
> > This patch adds support for the JZ4740 internal codec.
> > 
> > Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> > Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> > Cc: alsa-devel@alsa-project.org
> > ---
> >  sound/soc/codecs/Kconfig        |    4 +
> >  sound/soc/codecs/Makefile       |    2 +
> >  sound/soc/codecs/jz4740-codec.c |  502 +++++++++++++++++++++++++++++++++++++++
> >  sound/soc/codecs/jz4740-codec.h |   20 ++
> >  4 files changed, 528 insertions(+), 0 deletions(-)
> >  create mode 100644 sound/soc/codecs/jz4740-codec.c
> >  create mode 100644 sound/soc/codecs/jz4740-codec.h
> 
> no need for code in file name here.

My bad typing - I mean codec.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

