Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab1I0S40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:56:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55828 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426Ab1I0S4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:56:25 -0400
Date: Tue, 27 Sep 2011 19:56:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/6] ASoC: Remove unused "control_data" field of struct
 wm8904_priv
Message-ID: <20110927185623.GT4289@opensource.wolfsonmicro.com>
References: <1317127128.7207.1.camel@phoenix>
 <1317127222.7207.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317127222.7207.3.camel@phoenix>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 08:40:22PM +0800, Axel Lin wrote:
> The control_data field is used to initialize the codec's control_data field,
> but since this is also done by the snd-soc-cache core, the redundant
> assignment can be removed and the field can be dropped.

Applied all, thanks.
