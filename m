Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab1H2Lqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:46:42 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:41942 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab1H2Lqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:46:38 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Greg Freemyer <greg.freemyer@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [Drbd-dev] [RFC 000/118] drbd: part 1 of adding multiple volume support to drbd
Date: Mon, 29 Aug 2011 13:46:23 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; i686; ; )
Cc: drbd-dev@lists.linbit.com
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com> <CAGpXXZKem-uEdF4SyUgpQFV6=d5Vo3v9p3wmcaygAKa4w4x01w@mail.gmail.com>
In-Reply-To: <CAGpXXZKem-uEdF4SyUgpQFV6=d5Vo3v9p3wmcaygAKa4w4x01w@mail.gmail.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108291346.29847.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 26. August 2011, 15:20:51 schrieb Greg Freemyer:
> On Thu, Aug 25, 2011 at 11:06 AM, Philipp Reisner <
> 
> philipp.reisner@linbit.com> wrote:
> > This the first request for review of drbd-8.4. The complete set has
> > 500 patches. In this first series there are only 118 of these.
> 
> Lars,
> 
> I've only taken a quick glance, but is drbd functional between applying
> each patch?
> 
> It doesn't look like it to me, but I didn't look that close.  I also saw at
> least one patch that introduced a new function with no caller to test it.
> 
> The idea is that a patch series leave a testable / functional kernel after
> each patch in the series is applied sequentially.
> 
> That is the only way git bisect can do its job.
> 
> ie. Introducing a new function but no new caller makes a change, but there
> is no way to test it.  Therefore there is no real value in not merging that
> patch with one that has the new call in it.
> 

Greg,

You replied to mail 000. Please point out to which patch/function you
refer, so that we can fix this.

Best,
 Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
