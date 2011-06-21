Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab1FUBKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 21:10:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52991 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932069Ab1FUBKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 21:10:42 -0400
Date: Tue, 21 Jun 2011 02:10:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Cc: Taylor Hutt <thutt@chromium.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Olof Johansson <olofj@chromium.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: codecs: Max98095: Fix logging of hardware revision.
Message-ID: <20110621011038.GA4322@opensource.wolfsonmicro.com>
References: <1308596072-17158-1-git-send-email-thutt@chromium.org>
 <20110621002322.GE1905@opensource.wolfsonmicro.com>
 <B2150E1E4418E1438554A300EA5040E40DDEC16D42@ITSVLEX06.it.maxim-ic.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40DDEC16D42@ITSVLEX06.it.maxim-ic.internal>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 05:43:58PM -0700, Peter Hsiang wrote:

> I checked with hardware engineering and was told 0x40=RevA, 0x41=RevB..

> Would a raw value or the use of a 0x3F bit mask be more acceptable?

I don't mind (though it does seem like the high bit isn't part of the
actual data), it was just that it's a common error to assume that die
revisions and package revisions correspond directly.
