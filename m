Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab2IJB4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 21:56:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49444 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756700Ab2IJB4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 21:56:12 -0400
Date: Mon, 10 Sep 2012 09:56:01 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yunfan Zhang <yfzhang@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] regulator: Fairchild fan53555 support
Message-ID: <20120910015559.GA18071@opensource.wolfsonmicro.com>
References: <4737A960563B524DA805CA602BE04B3064CC590645@SC-VEXCH2.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4737A960563B524DA805CA602BE04B3064CC590645@SC-VEXCH2.marvell.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2012 at 03:52:18AM -0700, Yunfan Zhang wrote:
> This driver supports Fairchild FAN53555 Digitally Programmable
> TinyBuck Regulator. The FAN53555 is a step-down switching voltage
> regulator that delivers a digitally programmable output from an
> input voltage supply of 2.5V to 5.5V. The output voltage is
> programmed through an I2C interface.

Applied, thanks.
