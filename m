Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab2HULvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:51:32 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60809 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab2HULv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:51:29 -0400
Date: Tue, 21 Aug 2012 12:51:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH 1/1] ASoC: codecs: Enable AB8500 CODEC for Device Tree
Message-ID: <20120821115123.GE26899@gmail.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
 <1344527268-5964-9-git-send-email-lee.jones@linaro.org>
 <s5h628lu0q9.wl%tiwai@suse.de>
 <20120820113427.GN8450@gmail.com>
 <20120820143653.GE26991@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120820143653.GE26991@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 03:36:53PM +0100, Mark Brown wrote:
> On Mon, Aug 20, 2012 at 12:34:31PM +0100, Lee Jones wrote:
> > From: Lee Jones <lee.jones@linaro.org>
> > Date: Fri, 27 Jul 2012 08:50:05 +0100
> > Subject: [PATCH 1/1] ASoC: codecs: Enable AB8500 CODEC for Device Tree
> > 
> > We continue to allow the AB8500 CODEC to be registered via the AB8500
> > Multi Functional Device API, only this time we extract its configuration
> > from the Device Tree binary.
> 
> Please resend this series with all the acks you've got rather than
> mixing incremental updates in like this.

I'm waiting until I have a few more Acks before I resend the entire
patch-set again. Actually it's you and one other that I'm waiting for
to review (and Ack as necessary) the ones requested by Linus, then 
resend with the corrections.

> Please also send patches in
> the format documented in SubmittingPatches.

That's a big document, most of which I guess I'm adhering to. Care to
be a little more specific?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
