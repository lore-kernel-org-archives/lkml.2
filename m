Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab0JKW0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:26:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52986 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763Ab0JKW0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:26:23 -0400
Date: Tue, 12 Oct 2010 07:26:38 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: linux-next: manual merge of the sound-asoc tree with the s5p tree
In-reply-to: <20101011193336.835d9f78.sfr@canb.auug.org.au>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Liam Girdwood'" <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Dimitris Papastamos'" <dp@opensource.wolfsonmicro.com>
Message-id: <00eb01cb6993$61f84280$25e8c780$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: ActpHwgKjTRo/t+xTeWG7y6SljcW2wAdAipA
References: <20101011133519.cf4fcaa8.sfr@canb.auug.org.au>
 <009201cb6916$a9441740$fbcc45c0$%kim@samsung.com>
 <20101011193336.835d9f78.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi Kgene,
> 
> On Mon, 11 Oct 2010 16:33:48 +0900 Kukjin Kim <kgene.kim@samsung.com>
> wrote:
> >
> > > Today's linux-next merge of the sound-asoc tree got a conflict in
> > > arch/arm/mach-s3c64xx/dev-audio.c between commit
> > > f08269d850e4ee0cd028cf5279cc08259d0469df ("ARM: S3C64XX: Change to
> using
> > > s3c_gpio_cfgpin_range()") from the s5p tree and commit
> > > e4b6b74ffd32d114227a5dcfe814e2cecd80554b ("ARM: S3C64XX: Fix
> fallthrough
> > > bug in i2sv3 gpio configuration, improve logging") from the sound-asoc
> > > tree.
> > >
> > Hmm...how can/should I handle for it?
> 
> Don't worry about it.  It is trivial and both I and Linus can take care
> of it.
> 
Hi Stephen :-)

Thank you so much.
Have a nice day ;-)

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

