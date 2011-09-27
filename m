Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab1I0Jsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 05:48:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39635 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752661Ab1I0Jsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 05:48:37 -0400
Date: Tue, 27 Sep 2011 10:48:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [RFC][PATCH] ASoC: Make wm1250-ev1 depends on GPIOLIB
Message-ID: <20110927094835.GA2910@opensource.wolfsonmicro.com>
References: <1317091799.315.6.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317091799.315.6.camel@phoenix>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 10:49:59AM +0800, Axel Lin wrote:
> I got below build error if GPIO support is disabled.
> Make wm1250-ev1 depends on GPIOLIB to fix below build error.

If platforms aren't using the standard gpiolib infrastructure they
should keep their GPIO API implementation up to date with the current
state of the art.
