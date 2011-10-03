Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab1JCOIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 10:08:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46549 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135Ab1JCOI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 10:08:29 -0400
Date: Mon, 3 Oct 2011 15:08:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        linux-kernel@vger.kernel.org, "'Liam Girdwood'" <lrg@ti.com>
Subject: Re: [PATCH 5/6] ASoC: samsung: wm8994 depends on mfd_wm8994
Message-ID: <20111003140824.GM3731@opensource.wolfsonmicro.com>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
 <1869072.QQLATNzYYx@wuerfel>
 <20111003120741.GD23811@sirena.org.uk>
 <11174515.ANsqIhx0NX@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11174515.ANsqIhx0NX@wuerfel>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 03:43:10PM +0200, Arnd Bergmann wrote:

> > You've not sent a seprate patch for that one yet...

> I wasn't sure any more which version you wanted. Is this this right one?

I was expecting something that selects the core.  I was also expecting
something that can be applied against -next which this patch can't be,
this doesn't feel like something we should be rushing into 3.1.
