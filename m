Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab0GTPS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:18:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54824 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932077Ab0GTPSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:18:55 -0400
Date: Tue, 20 Jul 2010 16:18:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Tejun Heo <tj@kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] wm8960: fix compile error
Message-ID: <20100720151852.GA20241@rakim.wolfsonmicro.main>
References: <1279619362.11179.2.camel@mola>
 <20100720110722.GN10222@rakim.wolfsonmicro.main>
 <AANLkTinTT3_yy02wGJfKwannKT2rrZN899JKrdlvtLz7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinTT3_yy02wGJfKwannKT2rrZN899JKrdlvtLz7@mail.gmail.com>
X-Cookie: Klatu barada nikto.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 11:02:37PM +0800, Axel Lin wrote:
> 2010/7/20 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> > but please do try to bear in mind the feedback you've previously been
> > given about formatting your patches so they can be easily applied.  You

> I'm a little bit confused about the meaning of "formatting your patches"?
> Do you mean my patches cannot be applied by git am command? or?
> ( I tried the git am command with the mail I sent and it looks ok )

In this case the main thing is the subject line which is not consistent
with other subject lines for patches in this area of code.  This sort of
stuff is particularly important when you're submitting large numbers of
very small fixes.

> > probably also want to look at the CC list for your patches, I'm not sure
> > why you're CCing Tejun here.

> I get the CC list by get_maintainer.pl. Looks like the script gives me wrong
> CC list.

Yes, you need to apply a bit of taste to the output - it's inclined to
generate false positives.  For matches from MAINTAINERS it's good but
for things generated from the git logs it can easily miss people or pick
up people who've been doing kernel wide cleanup work.
