Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab2HAUCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:02:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47318 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755843Ab2HAUCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:02:39 -0400
Date: Wed, 1 Aug 2012 21:02:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: wm831x-ldo: Check return value of
 wm831x_reg_read()
Message-ID: <20120801200237.GP4483@opensource.wolfsonmicro.com>
References: <1343741306.6773.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343741306.6773.1.camel@phoenix>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 09:28:26PM +0800, Axel Lin wrote:
> wm831x_reg_read() returns negative error code on failure.
> This prevents using the error code as the value read.

Applied, thanks.
