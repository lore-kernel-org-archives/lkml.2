Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab1KDCQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 22:16:43 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59961 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab1KDCQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 22:16:42 -0400
Date: Fri, 4 Nov 2011 10:16:29 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        David Daney <ddaney.cavm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clocksource: Avoid selecting mult values that might
 overflow when adjusted
Message-ID: <20111104021629.GA14139@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1320264087-3413-1-git-send-email-john.stultz@linaro.org>
 <20111103031049.GA13681@zhy>
 <CAM_iQpV393oM4H_Ru3f7sbREiK8xQpD52nycADEuUqK4TJUT7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM_iQpV393oM4H_Ru3f7sbREiK8xQpD52nycADEuUqK4TJUT7g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 05:36:49PM +0800, Américo Wang wrote:
> On Thu, Nov 3, 2011 at 11:10 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> > On Wed, Nov 02, 2011 at 01:01:27PM -0700, John Stultz wrote:
> >> +     WARN_ONCE(timekeeper.mult+adj >
> >> +                     timekeeper.clock->mult + timekeeper.clock->maxadj,
> >> +                     "Adjusting more then 11%%");
> >
> >                        s/then/than ; s/%%/%\n ?
> 
>        %      A '%' is written.  No argument is converted.  The
> complete conversion specification is '%%'.

Oh, thanks for pointing it out. But my point is just we need '\n' in
the end.

Thanks,
Yong
