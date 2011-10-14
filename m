Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194Ab1JNTf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:35:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51779 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932745Ab1JNTf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:35:56 -0400
Date: Fri, 14 Oct 2011 20:35:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Vladimir Barinov <vbarinov@embeddedalley.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/3] ASoC: tlv320aic3x: Convert codec->hw_read to
 snd_soc_read
Message-ID: <20111014193553.GH2931@opensource.wolfsonmicro.com>
References: <1318556120.6379.1.camel@phoenix>
 <1318556220.6379.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318556220.6379.3.camel@phoenix>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 09:37:00AM +0800, Axel Lin wrote:
> codec->hw_read is broken now, let's covert to snd_soc_read.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.  You really should CC the TI guys on this driver,
especially Jarkko, as they have been doing most of the work on it.
Vladimir hasn't been very active since the initial contribution.
