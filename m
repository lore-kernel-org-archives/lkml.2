Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab1FFUxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:53:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46735 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757212Ab1FFUxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:53:13 -0400
Date: Mon, 6 Jun 2011 21:53:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] ASoC: AD1836: Add AD1835/AD1837/AD1838/AD1839 support
Message-ID: <20110606205310.GA27341@opensource.wolfsonmicro.com>
References: <1307360320-4727-1-git-send-email-lars@metafoo.de>
 <1307360320-4727-4-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307360320-4727-4-git-send-email-lars@metafoo.de>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 01:38:38PM +0200, Lars-Peter Clausen wrote:
> The AD183X codec devices are mostly register compatible and can easily be
> supported by the same driver.
> The main difference between those devices is the number of DACs and ADCs.

Please try to fix whatever it is gives this really weird word wrapping
in your changelogs - they frequently have line breaks in the middle of
paragraphs for some reason.
