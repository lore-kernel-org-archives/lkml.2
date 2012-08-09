Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab2HISuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 14:50:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43968 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753956Ab2HISub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 14:50:31 -0400
Date: Thu, 9 Aug 2012 19:50:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 00/22] mop500 related Audio reorganisation and fixups
Message-ID: <20120809185029.GC24328@opensource.wolfsonmicro.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 04:47:26PM +0100, Lee Jones wrote:
> Another fine instalment of Audio fixes and Device Tree enablement
> surrounding the mop500 sound driver. Hopefully containing all of 
> the recommendations suggested by Mark Brown.

Can we have some review of this from the ARM side please?  It's pretty
big...
