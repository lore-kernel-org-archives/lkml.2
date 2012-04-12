Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761922Ab2DLNMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 09:12:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57295 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab2DLNMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 09:12:13 -0400
Date: Thu, 12 Apr 2012 21:11:59 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org
Subject: Re: [PATCH 00/13] common clk framework misc fixes
Message-ID: <20120412131155.GI2445@S2101-09.ap.freescale.net>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
 <201204121114.38825.arnd.bergmann@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204121114.38825.arnd.bergmann@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 11:14:38AM +0000, Arnd Bergmann wrote:
> On Thursday 12 April 2012, Mike Turquette wrote:
> > This series collects many of the fixes posted for the recently merged
> > common clock framework as well as some general clean-up.  Most of the
> > code classifies as a clean-up moreso than a bug fix; hopefully this is
> > not a problem since the common clk framework is new code pulled for 3.4.
> > 
> > Patches are based on v3.4-rc2 and can be pulled from:
> > git://git.linaro.org/people/mturquette/linux.git v3.4-rc2-clk-fixes
> > 
> > Please let me know I missed any critical fixes that were posted to the
> > list already.
> > 
> > Arnd & Olof, if there are no objections to these changes can this get
> > pulled through the arm-soc tree?
> 
> I think pulling it in through the arm-soc tree is still ok, but it's
> borderline because of the size and patch 13 is probably too big,
> in addition to the comments that were made there.
> 
> Let's pull patches 1 through 12 in to a separate series that we don't
> mix with the other bug fixes. Mike, please send a pull request with the
> Acks added in.
> 
I just appended 3 more patches to the series.  Patches #1 and #2 change
the interface between clk core and clk drivers - clk_ops a little bit,
(this is something Mike acked a couple of weeks ago, but missed from
the series) and patch #3 is a critical bug fix.  So unless we can send
the whole series for -rc, I'd vote we send none of them for -rc.
Instead, we can stabilize it somewhere and ask all the clk driver
porting base on that.

Sending part of the cleanup/fixup and leaving the other that could
require changes on clk drivers out is a bad idea to me.

-- 
Regards,
Shawn
