Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab1LVJaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 04:30:10 -0500
Received: from relay1.sgi.com ([192.48.179.29]:38097 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab1LVJaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 04:30:06 -0500
Date: Thu, 22 Dec 2011 03:30:04 -0600
From: Robin Holt <holt@sgi.com>
To: Kay Sievers <kay.sievers@vrfy.org>, Jack Steiner <steiner@sgi.com>,
        Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Greg Kroah-Hartmann <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: question about link_mem_sections()
Message-ID: <20111222093004.GH2547@sgi.com>
References: <CAPXgP10gRKAgo1ExkvLyNqceKpGujcov90umPQCRiNJ=qTwU_A@mail.gmail.com>
 <20111212124538.GC2547@sgi.com>
 <CAPXgP10SU77-S9kerb5UwhNB3yAgg_6zAmeLpDpGFTq+yTbY=w@mail.gmail.com>
 <20111212134937.GE2547@sgi.com>
 <CAPXgP11EBq-b1n7GS4qwS=Kco8yKsy2cRXJ7=iWO=z_GeJN9og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPXgP11EBq-b1n7GS4qwS=Kco8yKsy2cRXJ7=iWO=z_GeJN9og@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 02:18:47AM +0100, Kay Sievers wrote:
> On Mon, Dec 12, 2011 at 14:49, Robin Holt <holt@sgi.com> wrote:
> > On Mon, Dec 12, 2011 at 02:11:28PM +0100, Kay Sievers wrote:
> 
> > If you do decide to rework that logic, we can retest for the next couple
> > months.  We do not normally have a 16TB test machine lying around (IIRC,
> > the memory in something like that costs a couple million dollars), but we
> > do fortunately have one right now until the latter part of next quarter.
> 
> The rework of the sys_devices with the goal to finally removal of all
> sysdev stuff is in Greg's tree now:
>   http://git.kernel.org/?p=linux/kernel/git/gregkh/driver-core.git;a=shortlog;h=refs/heads/driver-core-next
> It will be available in linux-next.
> 
> The hinted search moved from the 'kobject' to the 'bus' as:
>   dev = subsys_find_device_by_id(&memory_subsys, block_id, hintdev);
> 
> Would be nice if you can eventually give it a try, on the big box, to
> make sure we didn't break anything.

If it is in linux-next, we may already have it.

Russ or Jack, IIRC, you had been doing some testing with linux-next
on the 16TB machine.  Is that correct?  If so, do you happen to have a
timed boot log that we could look at?

Thanks,
Robin
