Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab1JBUtF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 16:49:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39915 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979Ab1JBUs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 16:48:57 -0400
Date: Sun, 2 Oct 2011 21:48:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>
Subject: Re: [PATCH 6/6] ASoC: samsung: add missing __devexit_p() annotations
Message-ID: <20111002204852.GD5811@opensource.wolfsonmicro.com>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
 <1317587284-2776-7-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317587284-2776-7-git-send-email-arnd@arndb.de>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 10:28:04PM +0200, Arnd Bergmann wrote:
> Drivers that refer to a __devexit function in an operations
> structure need to annotate that pointer with __devexit_p so
> replace it with a NULL pointer when the section gets discarded.

Again Axel already fixed these (and the other Samsung CPU drivers).
