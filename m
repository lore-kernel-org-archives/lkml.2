Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab0JNWGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 18:06:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932206Ab0JNWGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 18:06:30 -0400
Date: Thu, 14 Oct 2010 15:05:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: hardpps patch by Alexander Gordeev
Message-Id: <20101014150541.bbbbd74d.akpm@linux-foundation.org>
In-Reply-To: <20101014145751.5fc4adb6.rdunlap@xenotime.net>
References: <4CB3488F.8030108@xs4all.nl>
	<20101014145751.5fc4adb6.rdunlap@xenotime.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010 14:57:51 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Mon, 11 Oct 2010 19:25:35 +0200 Udo van den Heuvel wrote:
> 
> > Hello,
> > 
> > Can anybody here explain the status of Alexander Gordeev's harddpps patches?
> > Are they on the list to be included in the kernel?
> > Is work on the patches needed?
> > 
> > Thanks for your comment.
> 
> It's in Andrew Morton's mmotm tree.
> Where/when it goes from there to Linus's tree is a good question.

I didn't merge it into 2.6.36 and it's looking doubtful for 2.6.37. 
There were a number of issues identified during review and afaik they
remain up in the air.

My notes-to-self from the series file:

pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
#pps-fix-race-in-pps_fetch-handler.patch: Vitezslav Samel <vitezslav@samel.cz> q, TBU
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
#pps-access-pps-device-by-direct-pointer.patch: Rodolfo issues
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-add-async-pps-event-handler.patch
pps-add-async-pps-event-handler-fix.patch
pps-dont-disable-interrupts-when-using-spin-locks.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
ntp-add-hardpps-implementation.patch
#pps-capture-monotonic_raw-timestamps-as-well.patch: John had Q, TBU
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

(where TBU = "to be updated").

There may be other issues - one would need to go back and review the review
thread.
