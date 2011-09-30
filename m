Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482Ab1I3LvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 07:51:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45951 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758417Ab1I3LvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 07:51:05 -0400
Date: Fri, 30 Sep 2011 12:51:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@linux.intel.com>,
        Harsha Priya <priya.harsha@intel.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: sn95031: Do not use static variable for
 channel_index
Message-ID: <20110930115103.GE5366@opensource.wolfsonmicro.com>
References: <1317362219.6646.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317362219.6646.2.camel@phoenix>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 01:56:59PM +0800, Axel Lin wrote:
> No reason to use static variable for channel_index.

Applied, thanks.
