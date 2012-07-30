Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab2G3PH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:07:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33974 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754144Ab2G3PH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:07:56 -0400
Date: Mon, 30 Jul 2012 16:07:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 01/18] Documentation: Describe the ux500 realated audio
 related DT nodes
Message-ID: <20120730150753.GH4468@opensource.wolfsonmicro.com>
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
 <1343393162-11938-2-git-send-email-lee.jones@linaro.org>
 <20120729203106.GD4384@opensource.wolfsonmicro.com>
 <50163A09.8060203@linaro.org>
 <20120730134804.GE4468@opensource.wolfsonmicro.com>
 <50169AE8.4020601@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50169AE8.4020601@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 03:32:08PM +0100, Lee Jones wrote:
> On 30/07/12 14:48, Mark Brown wrote:

> >Which is part of the problem here, it makes it much harder to tell what
> >you need to do for the individual devices.

> Once again, I'll split them out, but I think there are people
> talking about documentation consolidation, as it's going to become
> very messy, very quickly if we keep adding new files for each
> device. Soon the Documentation directory will be as large as the
> driver base. :)

Well, that's device tree for you.  You can probably get away with a
single document if there's no differences but as soon as you get into
anything where you've got custom properties and no overlap you need to
start splitting things out.
