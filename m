Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1JBS4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:56:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52163 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716Ab1JBS4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:56:32 -0400
Date: Sun, 2 Oct 2011 19:56:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Fix setting update bits for WM8753_LADC and
 WM8753_RADC
Message-ID: <20111002185630.GI2857@opensource.wolfsonmicro.com>
References: <1317559264.21926.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317559264.21926.1.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 08:41:04PM +0800, Axel Lin wrote:
> Current code set update bits for WM8753_LDAC and WM8753_RDAC twice,
> but missed setting update bits for WM8753_LADC and WM8753_RADC.
> 
> I think it is a copy-paste bug in commit 776065
> "ASoC: codecs: wm8753: Fix register cache incoherency".

Looks like it, yes.  Applied, thanks.
