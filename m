Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705Ab1JGKNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:13:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37571 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752279Ab1JGKNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:13:52 -0400
Date: Fri, 7 Oct 2011 11:13:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: wm_hubs: Remove unneeded count variable in
 wait_for_dc_servo
Message-ID: <20111007101350.GC19080@opensource.wolfsonmicro.com>
References: <1317974065.16830.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317974065.16830.1.camel@phoenix>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 03:54:25PM +0800, Axel Lin wrote:
> The count variable is not required, decrement timeout in the while loop
> can achieve the same effect.

Having the count original timeout there is helpful when debugging and
there's not going to be any meaningful cost from having both.
