Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab0GTLH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 07:07:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59150 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757218Ab0GTLHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 07:07:24 -0400
Date: Tue, 20 Jul 2010 12:07:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Tejun Heo <tj@kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] wm8960: fix compile error
Message-ID: <20100720110722.GN10222@rakim.wolfsonmicro.main>
References: <1279619362.11179.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279619362.11179.2.camel@mola>
X-Cookie: Who was that masked man?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 05:49:22PM +0800, Axel Lin wrote:

> This patch is against Liam's multi-component branch.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but please do try to bear in mind the feedback you've previously been
given about formatting your patches so they can be easily applied.  You
probably also want to look at the CC list for your patches, I'm not sure
why you're CCing Tejun here.
