Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067Ab1LGQcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:32:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47016 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757725Ab1LGQcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:32:11 -0500
Date: Wed, 7 Dec 2011 17:32:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Josh Boyer <jwboyer@gmail.com>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: atl1c: WARNING: at net/sched/sch_generic.c:255 dev_watchdog
Message-ID: <20111207163208.GA1840@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Josh Boyer <jwboyer@gmail.com>, netdev@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20111206232741.GA5368@x1.osrc.amd.com>
 <CA+5PVA7bM8ZGaCiyZdHcMVccJYh2=bk-gsHLo9ZmBP_SYT208w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+5PVA7bM8ZGaCiyZdHcMVccJYh2=bk-gsHLo9ZmBP_SYT208w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 07:12:21PM -0500, Josh Boyer wrote:
> On Tue, Dec 6, 2011 at 6:27 PM, Borislav Petkov <bp@alien8.de> wrote:
> > Hi,
> >
> > this seems like a pretty old issue judging by a quick net search. It
> > still triggers on latest -rc4 here, below the whole trace. I'm willing
> > to test patches :).
> >
> > [14622.820555] atl1c 0000:02:00.0: atl1c: eth0 NIC Link is Up<100 Mbps Full Duplex>
> > [14632.816280] ------------[ cut here ]------------
> > [14632.816314] WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0x237/0x240()
> > [14632.816323] Hardware name: 30515QG
> > [14632.816332] NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
> 
> Matthew Garrett has a patch to the atl1c driver that changed it's ASPM
> behavior that seemed to help.  Dave Miller applied it, but I don't see
> it in linux-next for some reason.

Yeah, he reverted them due to build issues. I'm not sure they'll be
coming back though, judging by the thread.

Thanks.

-- 
Regards/Gruss,
Boris.
