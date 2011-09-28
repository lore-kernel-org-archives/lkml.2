Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab1I1MUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 08:20:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41225 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752997Ab1I1MUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 08:20:10 -0400
Date: Wed, 28 Sep 2011 13:20:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Joonyoung Shim <jy0922.shim@samsung.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/6] ASoC: Remove unused "control_data" field of struct
 ak4671_priv
Message-ID: <20110928122008.GD3279@opensource.wolfsonmicro.com>
References: <1317175218.14102.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317175218.14102.1.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 10:00:18AM +0800, Axel Lin wrote:
> The control_data field is used to initialize the codec's control_data field,
> but since this is also done by the snd-soc-cache core, the redundant
> assignment can be removed and the field can be dropped.

Applied all, thanks.
