Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab1K1Sxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 13:53:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38006 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223Ab1K1Sxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 13:53:50 -0500
Date: Mon, 28 Nov 2011 18:53:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, drivers@analog.com,
        device-drivers-devel@blackfin.uclinux.org
Subject: Re: [PATCH 3/7] ASoC: AD193X: Make enum items const char * const
Message-ID: <20111128185345.GA1586@opensource.wolfsonmicro.com>
References: <1322497692-27868-1-git-send-email-lars@metafoo.de>
 <1322497692-27868-3-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322497692-27868-3-git-send-email-lars@metafoo.de>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 05:28:08PM +0100, Lars-Peter Clausen wrote:

> -static const char *ad193x_deemp[] = {"None", "48kHz", "44.1kHz", "32kHz"};
> +static const char * const ad193x_deemp[] = {"None", "48kHz", "44.1kHz", "32kHz"};

Ideally this would be converted to a switch and the driver would
automatically select the rate based on the current sample rate.
