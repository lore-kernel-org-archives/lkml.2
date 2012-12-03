Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab2LCGLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 01:11:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47646 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766Ab2LCGLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 01:11:20 -0500
Date: Mon, 3 Dec 2012 15:11:13 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Jeong <gshark.jeong@gmail.com>
Cc: Liam Gridwood <lrg@ti.com>, Daniel Jeong <daniel.jeong@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] regulator: new driver for LP8755
Message-ID: <20121203061112.GA9848@opensource.wolfsonmicro.com>
References: <1354509864-30001-1-git-send-email-gshark.jeong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354509864-30001-1-git-send-email-gshark.jeong@gmail.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 01:44:23PM +0900, Daniel Jeong wrote:
> From: Daniel Jeong <daniel.jeong@ti.com>
> 
> This driver is a general version for lp8755 regulator driver of TI.
> 
> LP8755 :
> The LP8755 is a high performance power management unit.It contains
> six step-down DC-DC converters which can be filexibly bundled
> together in multiphase converters as required by application.

Don't send cover letters for single patches. If doing this either you
need to improve your patch description or the cover letter is adding
nothing.
