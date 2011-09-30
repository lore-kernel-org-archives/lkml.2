Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab1I3M4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:56:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55106 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940Ab1I3M4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:56:11 -0400
Date: Fri, 30 Sep 2011 13:56:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        Peter Hsiang <peter.hsiang@maxim-ic.com>,
        Jesse Marroquin <jesse.marroquin@maxim-ic.com>
Subject: Re: [PATCH 1/2] ASoC: Add BUG() assertion if max98088_get_channel
 returns -EINVAL
Message-ID: <20110930125609.GK5366@opensource.wolfsonmicro.com>
References: <1317218471.8008.3.camel@phoenix>
 <4E83AA77.9040700@gmail.com>
 <20110929103413.GK3697@opensource.wolfsonmicro.com>
 <4E84FBA6.40600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E84FBA6.40600@gmail.com>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 09:13:42AM +1000, Ryan Mallon wrote:

> How about something like this (untested) patch?

Looks plausible.
