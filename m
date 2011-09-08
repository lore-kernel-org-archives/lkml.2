Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab1IHXCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:02:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43276 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753875Ab1IHXCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:02:10 -0400
Date: Thu, 8 Sep 2011 15:43:32 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Roy Huang <roy.huang@analog.com>,
        Cliff Cai <cliff.cai@analog.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: ad1980: Return proper error if vendor id mismatch
Message-ID: <20110908224328.GA5980@opensource.wolfsonmicro.com>
References: <1315276668.9619.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315276668.9619.1.camel@phoenix>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 10:37:48AM +0800, Axel Lin wrote:
> Return -ENODEV instead of 0 if vendor id mismatch.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.
