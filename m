Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab1JBVaE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 17:30:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60734 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195Ab1JBVaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 17:30:01 -0400
Date: Sun, 2 Oct 2011 22:29:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>
Subject: Re: [PATCH 5/6] ASoC: samsung: fix Kconfig dependencies
Message-ID: <20111002212958.GD4506@opensource.wolfsonmicro.com>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
 <1317587284-2776-6-git-send-email-arnd@arndb.de>
 <20111002204729.GC5811@opensource.wolfsonmicro.com>
 <3289863.m6ULFZUV3p@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3289863.m6ULFZUV3p@wuerfel>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 11:14:55PM +0200, Arnd Bergmann wrote:

> So should SND_SOC_WM8994 instead select MFD_WM8994? That would mean adding
> the select only in one place.

select ignores the dependencies of the things it selects which isn't
enormously helpful for this sort of stuff.
