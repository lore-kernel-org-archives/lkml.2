Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab1JQXZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 19:25:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54434 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753648Ab1JQXZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 19:25:49 -0400
Date: Tue, 18 Oct 2011 00:25:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/2] ASoC: wm9081: Use snd_soc_update_bits for
 read-modify-write
Message-ID: <20111017232547.GB2559@opensource.wolfsonmicro.com>
References: <1318826212.12989.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318826212.12989.2.camel@phoenix>
X-Cookie: You will be surrounded by luxury.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 12:36:52PM +0800, Axel Lin wrote:
> Use snd_soc_update_bits for read-modify-write register access instead of
> open-coding it using snd_soc_read and snd_soc_write

Something in here is breaking audio through the WM9081 on Speyside.  I
can't immediately spot anything wrong but the behaviour is quite obvious
in the system.
