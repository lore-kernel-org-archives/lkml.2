Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab1JDLFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 07:05:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58837 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754715Ab1JDLFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 07:05:46 -0400
Date: Tue, 4 Oct 2011 12:05:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: axel.lin@gmail.com, linux-kernel@vger.kernel.org, lrg@ti.com,
        alsa-devel@alsa-project.org, peter.hsiang@maxim-ic.com,
        jesse.marroquin@maxim-ic.com, hidave.darkstar@gmail.com
Subject: Re: [PATCH 1/2] ASoC: max98088 codec: Catch driver bugs for eq
 channel name
Message-ID: <20111004110545.GI3250@opensource.wolfsonmicro.com>
References: <1317682541-28494-1-git-send-email-rmallon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317682541-28494-1-git-send-email-rmallon@gmail.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 09:55:40AM +1100, Ryan Mallon wrote:
> Move the EQ channel names to a separate array and iterate over it in
> max98088_get_channel rather than duplicating the hardcoded channel
> names. Add an error message if an invalid channel is passed and check
> the error in the callers.

Applied both, thanks.
