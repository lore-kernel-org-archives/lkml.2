Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab2BGQyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:54:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816Ab2BGQyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:54:54 -0500
Date: Tue, 7 Feb 2012 17:54:52 +0100
From: Jan Kara <jack@suse.cz>
To: Gerard Saraber <gsaraber@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Soft lockup problem
Message-ID: <20120207165452.GA1043@quack.suse.cz>
References: <CAOgv-ziomS-+ML0Xb4oSoWTjzkG8BBBQcMjXwn7rjQV2pFtQ6Q@mail.gmail.com>
 <20120206225122.GF24840@quack.suse.cz>
 <CAOgv-zjjwoTnN7=a1kRHL_yVRzc5w3BfUfsY0_X61-rjzJJ2Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOgv-zjjwoTnN7=a1kRHL_yVRzc5w3BfUfsY0_X61-rjzJJ2Hg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 07-02-12 10:35:37, Gerard Saraber wrote:
> On Mon, Feb 6, 2012 at 4:51 PM, Jan Kara <jack@suse.cz> wrote:
> > On Mon 06-02-12 09:40:45, Gerard Saraber wrote:
> >> Greetings everyone,
> >> I've been having a bit of a problem since upgrading to the linux 3.x
> >> series, I have a machine that we're using as a NAS that runs various
> >> rsync processes (mostly at night), lately after a day or two, I will
> >> come in in the morning to a load average of 49, but the machine not
> >> really doing anything, when trying to run 'dstat' the command just
> >> hung with no output at all. there were no errors in the logs, or even
> >> anything that would vaguely point at anything I could work with.
> >> So needing to get the machine back to work I attempted to reboot it
> >> "shutdown -r now" on console... it gives a nice message saying it's
> >> going to reboot, but nothing ever happens.. the only way to reboot it
> >> is by using ctrl + alt + sysrq + b. after which the machine reboots
> >> and the raid array comes back clean.
> >>
> >> I'm not sure how to troubleshoot this, any pointers would be appreciated.
> >>
> >> I'm compiling 3.2.4 at the moment and found a bunch of possibly useful
> >> options in the kernel debugging section:
> >> detect hard/soft lockups and detect hung tasks, maybe it'll give me
> >> something more to go on.
> >>
> >> Some details about the machine:
> >> Linux xenbox 3.2.2 #1 SMP Sun Jan 29 10:28:22 CST 2012 x86_64 Intel(R)
> >> Xeon(R) CPU 5140 @ 2.33GHz GenuineIntel GNU/Linux
> >> It has 3 software raid arrays (2 x 5 drives and 1 x 4 drives) LVM'ed
> >> together into a 23TB XFS filesystem.
> >> 6GB memory and a pair of Intel Gigabit ethernet controllers bonded together.
> >  Hmm, might be some deadlock in the filesystem. Adding XFS guys to CC.
> > Can you run 'echo w >/proc/sysrq-trigger' and post output of dmesg here?
> >
> >                                                                Honza
> > --
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> 
> Thanks for the quick reply,
> the machine is running good at the moment so I'm not sure if the
> output helps, but here it is:
> [I'll also be sure to grab this log the next time it locks]
  Yeah. Sorry, I was not clear but I meant you should grab the traces when
the machine locks up again...
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
