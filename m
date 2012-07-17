Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab2GQGD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 02:03:27 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:59756 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754195Ab2GQGD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 02:03:26 -0400
MIME-Version: 1.0
In-Reply-To: <87ipdnein1.fsf@ti.com>
References: <1341997995-14020-1-git-send-email-tarun.kanti@ti.com>
 <1341997995-14020-3-git-send-email-tarun.kanti@ti.com> <87394xhocn.fsf@ti.com>
 <CACRpkdZMG_ZHW_eGGrdrJh1SuO_=hOObijzmxG1ob6RoNf_dwg@mail.gmail.com>
 <87a9z4g9bi.fsf@ti.com> <CACRpkdZxUpQ=a-yQ8b4bnX3S9penPWkxJ+PG2Zi4i9YZibYRiw@mail.gmail.com>
 <87ipdnein1.fsf@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Tue, 17 Jul 2012 11:33:04 +0530
Message-ID: <CAMQu2gwvPuGBWc+R651EiDqHMcGQEF6SZBNpwJZ=Kxh8hwov2A@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio/omap: add *remove* callback in platform_driver
To: Kevin Hilman <khilman@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 10:40 PM, Kevin Hilman <khilman@ti.com> wrote:
>
> Linus Walleij <linus.walleij@linaro.org> writes:
>
> > On Thu, Jul 12, 2012 at 7:48 PM, Kevin Hilman <khilman@ti.com> wrote:
> >
> >> In the case of OMAP GPIO, unless it's an obvious fix, I would recommend
> >> you wait at least until you see some acks/tested tags from any of
> >>
> >> - Santosh Shilimkar <santosh.shilimkar@ti.com>
> >> - Rajendra Nayak <rnayak@ti.com>
> >> - Benoit Cousson <b-cousson@ti.com>
> >>
> >> or Tony, Paul or myself.
> >
> > Instead of trying to store this information in my and Grants brains and
> > us forgetting it, what about patching MAINTAINERS to reflect the fact
> > instead? That's better I think, plus I use that file a lot.
> >
> >> For major series, I have been collecting/queueing them for Grant after
> >> ensuring they have been well reviewed and well tested (although I am
> >> eagerly hoping to hand off this role to someone else.)
> >
> > Listing it under your GIT tree in MAINTAINERS for this driver will make
> > this work better I think.
> >
> > One path for OMAP GPIO patches, simple. It's obviously the
> > ambiguity that cause the trouble. Then you can also decide
> > on each cycle whether to send these to GPIO or ARM SoC
> > etc.
>
> Yeah, I understand the process, but I've been avoiding doing that
> because, well, I don't want the job.  I have been trying to get someone
> else at TI to maintain this driver, but have not been successful.
>
> So, until that happens, feel free to queue up the patch below.
>
> Santosh, note that I've put you as co-maintainer of this driver.
>
No problem Kevin.

Regards
Santosh
