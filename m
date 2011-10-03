Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab1JCMH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 08:07:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54861 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab1JCMHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 08:07:50 -0400
Date: Mon, 3 Oct 2011 13:07:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        linux-kernel@vger.kernel.org, "'Liam Girdwood'" <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 5/6] ASoC: samsung: fix Kconfig
 dependencies
Message-ID: <20111003120741.GD23811@sirena.org.uk>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
 <3289863.m6ULFZUV3p@wuerfel>
 <004e01cc8198$848347f0$8d89d7d0$@com>
 <1869072.QQLATNzYYx@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1869072.QQLATNzYYx@wuerfel>
X-Cookie: Batteries not included.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 01:50:08PM +0200, Arnd Bergmann wrote:

> the patch. The other problem in this patch is still there, with
> CONFIG_SND_SOC_SMDK_WM8994_PCM=y and CONFIG_MFD_WM8994=n:

You've not sent a seprate patch for that one yet...
