Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab1JCOkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 10:40:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53801 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753529Ab1JCOkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 10:40:31 -0400
Date: Mon, 3 Oct 2011 15:40:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        linux-kernel@vger.kernel.org, "'Liam Girdwood'" <lrg@ti.com>
Subject: Re: [PATCH v3] ASoC: samsung: wm8994 depends on mfd_wm8994
Message-ID: <20111003144023.GO3731@opensource.wolfsonmicro.com>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
 <11174515.ANsqIhx0NX@wuerfel>
 <20111003140824.GM3731@opensource.wolfsonmicro.com>
 <1373438.oHCphrxVRr@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373438.oHCphrxVRr@wuerfel>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 04:35:46PM +0200, Arnd Bergmann wrote:

> I'm still confused, I thought you had NAKed the patch that selects the
> core because it ignores the dependencies. Here comes another variant,
> this time for your branch, and selecting the MFD driver directly while
> respecting its dependencies.

The problem with that one was that you had the select on the Kconfig for
the CODEC driver rather than on the machine drivers so you ended up with
the select being done from a symbol that is itself selected.

Applied this version, thanks.
