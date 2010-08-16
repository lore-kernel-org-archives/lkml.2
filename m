Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab0HPNFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 09:05:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:33545 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab0HPNFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 09:05:32 -0400
Subject: Re: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for
 samsung2GbX8
From: David Woodhouse <dwmw2@infradead.org>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <hzhuang1@marvell.com>, Lei Wen <leiwen@marvell.com>,
        Axel Lin <axel.lin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
In-Reply-To: <AANLkTimjKThiuNPhVyOh-SL1e7Zwu2R8Sd2DXAFixpY+@mail.gmail.com>
References: <AANLkTi=YSS0-Nf4MWOw30YDrCdrkmtzLhv7DXfsoJTjX@mail.gmail.com>
	 <53612FE6B944314AAADB181E45A45B64133DDFC156@sc-vexch3.marvell.com>
	 <AANLkTimh=dbUV75ZVXuhknt4FiMtximXLY8xoADfbe=q@mail.gmail.com>
	 <25B60CDC2F704E4E9D88FFD52780CB4C0597FEB568@SC-VEXCH1.marvell.com>
	 <AANLkTimjKThiuNPhVyOh-SL1e7Zwu2R8Sd2DXAFixpY+@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 14:05:19 +0100
Message-ID: <1281963920.21549.81.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 20:55 +0800, Eric Miao wrote:
> On Mon, Aug 16, 2010 at 8:49 PM, Haojian Zhuang <hzhuang1@marvell.com> wrote:
> > http://lists.infradead.org/pipermail/linux-mtd/2010-July/subject.html
> >
> > They're re-posted in July. Please search the subjects in that page. They're totally 29 patches.
> >
> > By the way, David, what's the result of review on these patches? We already posted for several times.
> >
> 
> I've actually reviewed some of the patches and gave my Ack. For those
> patches, I think they can be merged early.
>
> And overall, they look good. Yet 29 patch in a whole is still a bit too
> much, would be good to see them logically be separated into several
> patch series.

You had some criticism of patch #1 in the sequence, and some questions.

I didn't look much harder than that, iirc... although looking back now
it seems that the rest of your responses to the sequence were largely
positive.

Are you happy with the first patch, and if so shall I go ahead and
import the whole sequence with your Acked-By:?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

