Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab1BMMvD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 07:51:03 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:53233 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab1BMMu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 07:50:56 -0500
Date: Sun, 13 Feb 2011 13:50:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 00/75] genirq: Overhaul for 2.6.39
Message-ID: <20110213125053.GA28968@merkur.ravnborg.org>
References: <20110210222908.661199947@linutronix.de> <AANLkTi=waRQcvdxyKUgcLZ1r-hwUcAVZeVDcBa-apyK2@mail.gmail.com> <alpine.LFD.2.00.1102110058450.31804@localhost6.localdomain6> <AANLkTin3o9eFjpe6TMmKb5LSRUT+0Y2EpD4OU4LzN8Kd@mail.gmail.com> <alpine.LFD.2.00.1102110135320.31804@localhost6.localdomain6> <alpine.LFD.2.00.1102111359580.31804@localhost6.localdomain6> <20110211135906.GA16358@elte.hu> <alpine.LFD.2.00.1102111516020.31804@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1102111516020.31804@localhost6.localdomain6>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 03:26:11PM +0100, Thomas Gleixner wrote:
> On Fri, 11 Feb 2011, Ingo Molnar wrote:
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> > >  129 files changed, 4353 insertions(+), 5400 deletions(-)
> > 
> > Did I get the file count right - roughtly how many files are affected throughout all 
> > architectures? The changes are massively intrusive and widely spread out so we 
> > cannot do them in one go, right?
> 
> Alone the stuff which fiddles in irq_desc->status for whatever reasons
> is >100 files in arch/. And that has do be done manually case by case.

Some kind of arch TODO list wold be nice. Just to let the arch maintainers
know what you expect from them (on top of the deprecated warnings).

	Sam
