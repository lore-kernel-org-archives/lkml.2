Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab2HaHbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 03:31:40 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48183 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2HaHbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 03:31:38 -0400
Date: Fri, 31 Aug 2012 08:31:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 8/8] input: ab8500-ponkey: Rely on MFD core to convert
 IRQs to virtual
Message-ID: <20120831073123.GA13298@gmail.com>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
 <1344527635-6163-9-git-send-email-lee.jones@linaro.org>
 <CACRpkdZ-HOGy_sdsCQSNOdYTDzHFszk0OySM88TjO-neSJUz0A@mail.gmail.com>
 <20120821092328.GC26899@gmail.com>
 <20120821164244.GA4672@core.coreip.homeip.net>
 <20120830131202.GG14145@gmail.com>
 <20120830230221.GD21501@core.coreip.homeip.net>
 <20120830230323.GE21501@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120830230323.GE21501@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 04:03:23PM -0700, Dmitry Torokhov wrote:
> On Thu, Aug 30, 2012 at 04:02:21PM -0700, Dmitry Torokhov wrote:
> > On Thu, Aug 30, 2012 at 02:12:04PM +0100, Lee Jones wrote:
> > > > Sorry for the delay. Yes, this shoudl be fine, but since it is
> > > > essentially a revert of the original patch it should be pushed in as
> > > > such.
> > > 
> > > How's this?
> > > 
> > 
> > Excellent.
> 
> I assume you will be merging it with the rest of AB8500 patches, right?

Yes, if that's okay with you of course?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
