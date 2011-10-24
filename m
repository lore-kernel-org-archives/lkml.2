Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab1JXMIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:08:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43508 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932100Ab1JXMIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:08:50 -0400
Date: Mon, 24 Oct 2011 14:08:48 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: wm8400: Fix setting Fout clock divider for FLL
 Control 4
Message-ID: <20111024120847.GE6148@opensource.wolfsonmicro.com>
References: <1319294907.2678.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319294907.2678.2.camel@phoenix>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 22, 2011 at 10:48:27PM +0800, Axel Lin wrote:
> What we want here is to clear the WM8400_FLL_OUTDIV_MASK bits then
> OR with factors.outdiv.

Applied, thanks.
