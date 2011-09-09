Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898Ab1IITaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 15:30:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52898 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759244Ab1IITaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 15:30:15 -0400
Date: Fri, 9 Sep 2011 12:30:11 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jassi Brar <jassisinghbrar@gmail.com>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jarkko Nikula <jhnikula@gmail.com>, linaro-dev@lists.linaro.org,
        linux-omap@vger.kernel.org, Mans Rullgard <mans.rullgard@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ASoC: omap: convert per-board modules to platform
 drivers
Message-ID: <20110909193010.GA2993@opensource.wolfsonmicro.com>
References: <CAG5Tg6UOuztenNid1=YbH9a4ZH5MqV4YhohG+r9R+7F=zXs=CQ@mail.gmail.com>
 <3110288.bQbb0H2ME1@wuerfel>
 <1315520956.4126.3.camel@finisterre.wolfsonmicro.main>
 <20110908223720.GA21469@n2100.arm.linux.org.uk>
 <20110908224731.GB5201@opensource.wolfsonmicro.com>
 <20110908230102.GB21469@n2100.arm.linux.org.uk>
 <20110908235903.GA6370@opensource.wolfsonmicro.com>
 <20110909094156.GE6918@n2100.arm.linux.org.uk>
 <20110909161151.GA3515@opensource.wolfsonmicro.com>
 <20110909190134.GA14520@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110909190134.GA14520@n2100.arm.linux.org.uk>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 08:01:35PM +0100, Russell King - ARM Linux wrote:

> Well, with DT, there won't be any 'board type' anymore.  There won't be
> any 'machine_is_xxx()' to sort it out anymore.  Using DT, all that will
> be history - it's all got to be sorted out by either devices or device
> properties.

There is a board type - there's a root compatible property for the board
which fulfils this purpose - so the situation with and without device
tree is essentially the same.
