Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab1FUX2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:28:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59706 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756939Ab1FUX2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:28:48 -0400
Date: Wed, 22 Jun 2011 00:28:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Taylor Hutt <thutt@chromium.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Peter Hsiang <Peter.Hsiang@maxim-ic.com>,
        Olof Johansson <olofj@chromium.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: codecs: Max98095: Fix logging of hardware revision.
Message-ID: <20110621232846.GB8791@opensource.wolfsonmicro.com>
References: <1308596072-17158-1-git-send-email-thutt@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308596072-17158-1-git-send-email-thutt@chromium.org>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 11:54:32AM -0700, Taylor Hutt wrote:
> The base hardware revision of the Maxim 98095 part is 0x40; the code
> which outputs the revision of the hardware has been updated to
> properly use uppercase alphabetic values for the revision numbers.
> 
> Also, the use of a constant for the length 'max98095_dai' has been
> replaced with ARRAY_SIZE().

Applied.  Like I said in my previous mail please do try to split your
patches up better and make sure the changelogs are accurate.
