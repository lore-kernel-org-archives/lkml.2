Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab1JBUuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 16:50:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39934 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979Ab1JBUuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 16:50:00 -0400
Date: Sun, 2 Oct 2011 21:49:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 3/6] ASoC: imx: eukrea_tlv320 needs i2c
Message-ID: <20111002204958.GA4506@opensource.wolfsonmicro.com>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
 <1317587284-2776-4-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317587284-2776-4-git-send-email-arnd@arndb.de>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 10:28:01PM +0200, Arnd Bergmann wrote:
> Add a missing dependency that is required for random configurations.

Applied, thanks.
