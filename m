Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab0L1CP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 21:15:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48459 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752822Ab0L1CP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 21:15:27 -0500
Date: Tue, 28 Dec 2010 02:15:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20101228021538.GA30589@opensource.wolfsonmicro.com>
References: <20101228104024.fb0e9e34.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101228104024.fb0e9e34.sfr@canb.auug.org.au>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 10:40:24AM +1100, Stephen Rothwell wrote:

> In sound/soc/codecs/wm8962.c, the tracepoint is protected by
> CONFIG_SOUND_SOC_WM8962_MODULE, it should be CONFIG_SND_SOC_WM8962_MODULE.

Should be fixed now.
