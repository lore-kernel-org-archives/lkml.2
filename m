Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab2AYAPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:15:11 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:59714 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab2AYAPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:15:09 -0500
Message-ID: <1327450499.11738.45.camel@work-vm>
Subject: Re: [RFC][PATCH 2/3] clocksource: scx200_hrt: Convert scx200 to use
 clocksource_register_hz
From: John Stultz <john.stultz@linaro.org>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Date: Tue, 24 Jan 2012 16:14:59 -0800
In-Reply-To: <CAJfuBxw6M7LB_-GpmTxem-aqWz35CDDaaBv+8oqQ_R_SR7r_tQ@mail.gmail.com>
References: <1327363550-19952-1-git-send-email-john.stultz@linaro.org>
	 <1327363550-19952-3-git-send-email-john.stultz@linaro.org>
	 <CAJfuBxwBfB7V_gikW44rTNAYvxKZwORwzdRrvyZM19feFwcwDQ@mail.gmail.com>
	 <1327446024.11738.4.camel@work-vm>
	 <CAJfuBxw6M7LB_-GpmTxem-aqWz35CDDaaBv+8oqQ_R_SR7r_tQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012500-2398-0000-0000-000003A928F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-24 at 16:51 -0700, Jim Cromie wrote:
> On Tue, Jan 24, 2012 at 4:00 PM, John Stultz <john.stultz@linaro.org> wrote:
> > On Tue, 2012-01-24 at 11:53 -0700, Jim Cromie wrote:
> >> very nice.  Tested with mhz27 too.
> >>
> >> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> >
> > I assume you mean Acked-by:/Tested-by: ?  Or are you going to push this
> > upstream?
> >
> 
> huh - I thought SOB was appropriate since Im maintainer of scx200_hrt.
> That said, youre maintainer of TIMEKEEPING, and author of the patch,
> so I consider you upstream.  Lets make it instead:
> 
> Acked-by: Jim Cromie <jim.cromie@gmail.com>
> Tested-by: Jim Cromie <jim.cromie@gmail.com>

Thanks for clarifying. It might be good to review section 12-14 here (I
have to re-read it periodically myself):
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob_plain;f=Documentation/SubmittingPatches

If you're planning on distributing the patch yourself (pushing it up
towards Linus or giving it to someone else via a git tree or something),
then adding the signed-off-by would be appropriate (although not
necessarily in an email reply - usually just better to tell folks you've
queued it) before sending it onward.

Otherwise if you're not in the distribution path, an Acked-by: would be
more appropriate.

> Can you also push that trivial s/then/than/ patch I attached,
> and/or should I resend it inline, with git-send-email ?

Yep. I've just queued it into my tree. Thanks for that!

thanks
-john


