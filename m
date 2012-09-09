Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab2IIDFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 23:05:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47329 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725Ab2IIDFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 23:05:54 -0400
Date: Sun, 9 Sep 2012 11:05:47 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yunfan Zhang <yfzhang@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regmap: no need primary handler for nested irq
Message-ID: <20120909030545.GA27732@opensource.wolfsonmicro.com>
References: <4737A960563B524DA805CA602BE04B3064CC590646@SC-VEXCH2.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4737A960563B524DA805CA602BE04B3064CC590646@SC-VEXCH2.marvell.com>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2012 at 03:53:25AM -0700, Yunfan Zhang wrote:
> The primary handler will NOT be called if the interrupt nests into
> another interrupt thread. Remove it to avoid confusing.

Applied, thanks.
