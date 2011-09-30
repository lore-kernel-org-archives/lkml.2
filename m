Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab1I3Lu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 07:50:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45929 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758406Ab1I3Lu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 07:50:27 -0400
Date: Fri, 30 Sep 2011 12:50:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vladimir Barinov <vova.barinov@gmail.com>,
        Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/2] ASoC: Remove unused "control_data" field of struct
 aic3x_priv
Message-ID: <20110930115025.GC5366@opensource.wolfsonmicro.com>
References: <1317349870.4193.1.camel@phoenix>
 <1317349957.4193.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317349957.4193.3.camel@phoenix>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 10:32:37AM +0800, Axel Lin wrote:
> The control_data field is used to initialize the codec's control_data field,
> but since this is also done by the snd-soc-cache core, the redundant
> assignment can be removed and the field can be dropped.

Applied, thanks.
