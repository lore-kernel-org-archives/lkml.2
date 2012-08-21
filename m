Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab2HUM6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:58:19 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38785 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab2HUM6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:58:16 -0400
Date: Tue, 21 Aug 2012 13:58:12 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH 1/1] ASoC: codecs: Enable AB8500 CODEC for Device Tree
Message-ID: <20120821125811.GA931@gmail.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
 <1344527268-5964-9-git-send-email-lee.jones@linaro.org>
 <s5h628lu0q9.wl%tiwai@suse.de>
 <20120820113427.GN8450@gmail.com>
 <20120820143653.GE26991@opensource.wolfsonmicro.com>
 <20120821115123.GE26899@gmail.com>
 <20120821123951.GC7995@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120821123951.GC7995@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 01:39:51PM +0100, Mark Brown wrote:
> On Tue, Aug 21, 2012 at 12:51:24PM +0100, Lee Jones wrote:
> > On Mon, Aug 20, 2012 at 03:36:53PM +0100, Mark Brown wrote:
> 
> > > > From: Lee Jones <lee.jones@linaro.org>
> > > > Date: Fri, 27 Jul 2012 08:50:05 +0100
> 
> > > Please resend this series with all the acks you've got rather than
> > > mixing incremental updates in like this.
> 
> > I'm waiting until I have a few more Acks before I resend the entire
> > patch-set again. Actually it's you and one other that I'm waiting for
> > to review (and Ack as necessary) the ones requested by Linus, then 
> > resend with the corrections.
> 
> Well, I'm the person who's going to apply the patches so I'm unlikely
> to ack them...  I was waiting for arch/arm review before I looked at

I have all of Linus' Acks. The only ones missing are yours and Ola's,
but I think Ola is on vacation still, so he's asked Roger to do it.
I don't know if you saw, but Linus has placed lots of Acked-by's which
are dependent on your say-so, hence why I was waiting for your response.

> them due to the number of resends.

Bingo, thus why I was dubious about resending the entire patch-set too
prematurely.

> > > Please also send patches in
> > > the format documented in SubmittingPatches.
> 
> > That's a big document, most of which I guess I'm adhering to. Care to
> > be a little more specific?
> 
> The bit I quoted is the main example, you're including random mail
> headers in the body of the mail.

They're not mail headers per-say, they're `git format-patch` headers.
I thought this was acceptable for single patches, hence why I've done
it lots of times and had no complaints (until now).

If there are some changes required in a single patch, I usually fix
it up, create a patch with `git format-patch` and send it as a reply
to either the original patch in the series or the mail containing the
suggestion. If this is wrong please educate me as I thought this was
acceptable, as I thought it would be less pain than sending the
entire patch-set again for just one change?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
