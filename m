Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2JKInG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:43:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41237 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751656Ab2JKInD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:43:03 -0400
Date: Thu, 11 Oct 2012 17:42:49 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: codecs: da9055: Minor improvement in
 ALC calibration process
Message-ID: <20121011084247.GH11726@opensource.wolfsonmicro.com>
References: <1349944477.24126.11.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349944477.24126.11.camel@matrix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 02:04:37PM +0530, Ashish Chavan wrote:

> This patch slightly improves ALC calibration process of da9055 codec
> driver by muting Mic PGAs during calibration.

Applied, thanks.
