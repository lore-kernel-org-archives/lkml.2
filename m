Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab1JNTgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:36:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51798 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755528Ab1JNTgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:36:33 -0400
Date: Fri, 14 Oct 2011 20:36:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/2] ASoC: wm8400: Fix wrong bit setting for
 WM8400_POWER_MANAGEMENT_2
Message-ID: <20111014193631.GK2931@opensource.wolfsonmicro.com>
References: <1318571809.4610.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318571809.4610.1.camel@phoenix>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 01:56:49PM +0800, Axel Lin wrote:
> If (fakepower & ((1 << WM8400_INMIXR_PWR) | (1 << WM8400_AINRMUX_PWR)))
> is false, we should clear WM8400_AINR_ENA bits instead of WM8400_AINL_ENA.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied both, thanks.
