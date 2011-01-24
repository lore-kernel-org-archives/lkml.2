Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab1AXKV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 05:21:27 -0500
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:56846 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302Ab1AXKV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 05:21:26 -0500
Subject: Re: [PATCH] ARM: pxa: fix suspend on PXA3XX
From: Sven Neumann <s.neumann@raumfeld.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>, Daniel Mack <daniel@caiaq.de>
In-Reply-To: <1295864152-773-1-git-send-email-s.neumann@raumfeld.com>
References: <20110124095138.GC16202@n2100.arm.linux.org.uk>
	 <1295864152-773-1-git-send-email-s.neumann@raumfeld.com>
Content-Type: text/plain; charset="UTF-8"
Organization: RAUMFELD GmbH
Date: Mon, 24 Jan 2011 11:21:23 +0100
Message-ID: <1295864483.2044.31.camel@sven>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;s.neumann@raumfeld.com;1295864486;a6868627;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 11:15 +0100, Sven Neumann wrote:
> Resurrect the save and restore functions in pxa3xx_cpu_pm_fns
> so that pxa_pm_enter() won't crash. This fixes a regression
> introduced by commit aae8224d.
> 
> Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>

With this patch the crash is gone and the device enters suspend. It
still has resume problems, but this is the same as with 2.6.37 and needs
further investigation.


Sven


