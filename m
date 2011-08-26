Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab1HZOAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:00:39 -0400
Received: from mail09.linbit.com ([212.69.161.110]:52053 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab1HZOAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:00:38 -0400
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Aug 2011 10:00:38 EDT
Date: Fri, 26 Aug 2011 15:54:02 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [Drbd-dev] [RFC 000/118] drbd: part 1 of adding multiple
 volume support to drbd
Message-ID: <20110826135402.GS14479@barkeeper1-xen.linbit>
Mail-Followup-To: Greg Freemyer <greg.freemyer@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
	drbd-dev@lists.linbit.com
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
 <CAGpXXZKem-uEdF4SyUgpQFV6=d5Vo3v9p3wmcaygAKa4w4x01w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGpXXZKem-uEdF4SyUgpQFV6=d5Vo3v9p3wmcaygAKa4w4x01w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 09:20:51AM -0400, Greg Freemyer wrote:
> On Thu, Aug 25, 2011 at 11:06 AM, Philipp Reisner <
> philipp.reisner@linbit.com> wrote:
> 
> > This the first request for review of drbd-8.4. The complete set has
> > 500 patches. In this first series there are only 118 of these.
> >
> >
> Lars,
> 
> I've only taken a quick glance, but is drbd functional between applying each
> patch?
>
> It doesn't look like it to me, but I didn't look that close.  I also saw at
> least one patch that introduced a new function with no caller to test it.
> 
> The idea is that a patch series leave a testable / functional kernel after
> each patch in the series is applied sequentially.
>
> 
> That is the only way git bisect can do its job.

Very likely DRBD will not always be completely functional between
any arbitrary two of these patches.

The kernel as such will still be bisectable "just fine".

However if you hunt for DRBD internal bugs, "blindly" bisecting through
this pile of patches will not be too useful.

> ie. Introducing a new function but no new caller makes a change, but there
> is no way to test it.  Therefore there is no real value in not merging that
> patch with one that has the new call in it.

Right.


-- 
: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com

DRBD® and LINBIT® are registered trademarks of LINBIT, Austria.
