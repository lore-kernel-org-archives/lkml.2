Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab2G2UpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 16:45:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51326 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753469Ab2G2UpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 16:45:19 -0400
Date: Sun, 29 Jul 2012 21:45:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 10/18] ARM: ux500: Enable HIGHMEM on all mop500 platforms
Message-ID: <20120729204516.GJ4384@opensource.wolfsonmicro.com>
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
 <1343393162-11938-11-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343393162-11938-11-git-send-email-lee.jones@linaro.org>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 01:45:54PM +0100, Lee Jones wrote:
> The current kernel commandline for ux500 based devices includes
> hard-coded allocations for things like mali and hwmem, which
> actually run over lowmem. Here we enable highmem in order to
> avoid memory corruption errors.

This appears to be at best tangentially related to the rest of the
series, are you sure it shouldn't be being sent separately as a bugfix?
