Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2G3NmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 09:42:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36539 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754189Ab2G3NmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 09:42:23 -0400
Date: Mon, 30 Jul 2012 14:42:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 17/18] ARM: ux500: Add all encompassing Sound node to
 DB8500 Device Tree
Message-ID: <20120730134220.GD4468@opensource.wolfsonmicro.com>
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
 <1343393162-11938-18-git-send-email-lee.jones@linaro.org>
 <20120729205227.GL4384@opensource.wolfsonmicro.com>
 <50163936.1050901@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50163936.1050901@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 08:35:18AM +0100, Lee Jones wrote:
> On 29/07/12 21:52, Mark Brown wrote:

> >...this is clearly the board-specific setup for the system, showing how
> >the CPU and CODEC are hooked up.  This should therefore be in the DT for
> >whatever board this is you're working on.

> I don't think it's board specific. I believe this is the setup on
> all db8500 platforms. I'm happy to be told I'm wrong here, in which
> case I can move it to the board specific files.

I think that's more a sign that all the platforms you've seen are just
cut'n'pasted from the reference design than anything else.  If the thing
you're describing is on the PCB it's generally board specific...
