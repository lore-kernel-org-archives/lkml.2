Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab1JQXWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 19:22:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54422 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756144Ab1JQXWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 19:22:52 -0400
Date: Tue, 18 Oct 2011 00:22:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/2] ASoC: wm9081: Fix setting soft VMID ramp enable with
 VMID 2*240k
Message-ID: <20111017232249.GA2559@opensource.wolfsonmicro.com>
References: <1318826071.12989.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318826071.12989.0.camel@phoenix>
X-Cookie: You will be surrounded by luxury.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 12:34:31PM +0800, Axel Lin wrote:
> According to the datasheet:
> BIT 2:1

Applied, thanks.
