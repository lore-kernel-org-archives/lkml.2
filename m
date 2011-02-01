Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab1BASfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:35:45 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:51022 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab1BASfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:35:43 -0500
Subject: Re: [PATCH 2/2] hrtimers: Add CLOCK_BOOTTIME clockid, hrtimerbase
 and posix interface
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
        Alexander Shishkin <virtuoso@slind.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <alpine.LFD.2.00.1102011510570.31804@localhost6.localdomain6>
References: <1296531837-12879-1-git-send-email-john.stultz@linaro.org>
	 <1296531837-12879-3-git-send-email-john.stultz@linaro.org>
	 <alpine.LFD.2.00.1102011510570.31804@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 10:35:31 -0800
Message-ID: <1296585331.3336.14.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 15:16 +0100, Thomas Gleixner wrote:
> On Mon, 31 Jan 2011, John Stultz wrote:
> 
> > CLOCK_MONOTONIC stops while the system is in suspend. This is because
> > to applications system suspend is invisible. However, there is a
> > growing set of applications that are wanting to be suspend-aware,
> > but do not want to deal with the complicatoins of CLOCK_REALTIME
> > (which might jump around if settimeofday is called).
> > 
> > For these applications, I propose a new clockid: CLOCK_BOOTTIME.
> > CLOCK_BOOTTIME is idential to CLOCK_MONOTONIC, except it also
> > includes any time spent in suspend.
> > 
> > This patch adds the new CLOCK_BOOTTIME clockid, as well as the
> > infrastructure needed to support hrtimers against it, and the
> > wiring to expose it out via the posix interface.
> 
> Can you please split that into parts:
> 
>     - Add the new functions
>     - Wire up hrtimers, posix-timers

Will do. And will rebase to tip/timers/core.

thanks
-john


