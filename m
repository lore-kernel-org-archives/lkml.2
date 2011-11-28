Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab1K1TD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:03:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46644 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223Ab1K1TDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:03:25 -0500
Date: Mon, 28 Nov 2011 19:03:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, drivers@analog.com,
        device-drivers-devel@blackfin.uclinux.org
Subject: Re: [PATCH 3/7] ASoC: AD193X: Make enum items const char * const
Message-ID: <20111128190322.GE1586@opensource.wolfsonmicro.com>
References: <1322497692-27868-1-git-send-email-lars@metafoo.de>
 <1322497692-27868-3-git-send-email-lars@metafoo.de>
 <20111128185345.GA1586@opensource.wolfsonmicro.com>
 <4ED3DA92.6050704@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED3DA92.6050704@metafoo.de>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 08:01:38PM +0100, Lars-Peter Clausen wrote:
> On 11/28/2011 07:53 PM, Mark Brown wrote:
> > On Mon, Nov 28, 2011 at 05:28:08PM +0100, Lars-Peter Clausen wrote:

> >> -static const char *ad193x_deemp[] = {"None", "48kHz", "44.1kHz", "32kHz"};
> >> +static const char * const ad193x_deemp[] = {"None", "48kHz", "44.1kHz", "32kHz"};

> > Ideally this would be converted to a switch and the driver would
> > automatically select the rate based on the current sample rate.

> Ideally yes, but I'm not sure if this couldn't break some existing setup if it
> expects to find that control.

Well, it might but I'm not sure anyone actually uses deemphasis any more
anyway.
