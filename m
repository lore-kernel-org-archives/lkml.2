Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965059Ab1JGKXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:23:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55802 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752285Ab1JGKXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:23:34 -0400
Date: Fri, 7 Oct 2011 11:23:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 11/11] ASoC: wm8990: Convert to snd_soc_cache_sync
Message-ID: <20111007102326.GE19080@opensource.wolfsonmicro.com>
References: <1317944619.5579.1.camel@phoenix>
 <1317945413.5579.17.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317945413.5579.17.camel@phoenix>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 07:56:53AM +0800, Axel Lin wrote:
> Convert codec->hw_write to snd_soc_cache_sync

This doesn't apply against current code, mostly due to a version of the
patch already having been applied and a conflict with your subsequent
patch updating the comments.
