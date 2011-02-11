Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab1BKO1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:27:21 -0500
Received: from www.tglx.de ([62.245.132.106]:35840 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab1BKO1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:27:19 -0500
Date: Fri, 11 Feb 2011 15:26:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 00/75] genirq: Overhaul for 2.6.39
In-Reply-To: <20110211135906.GA16358@elte.hu>
Message-ID: <alpine.LFD.2.00.1102111516020.31804@localhost6.localdomain6>
References: <20110210222908.661199947@linutronix.de> <AANLkTi=waRQcvdxyKUgcLZ1r-hwUcAVZeVDcBa-apyK2@mail.gmail.com> <alpine.LFD.2.00.1102110058450.31804@localhost6.localdomain6> <AANLkTin3o9eFjpe6TMmKb5LSRUT+0Y2EpD4OU4LzN8Kd@mail.gmail.com>
 <alpine.LFD.2.00.1102110135320.31804@localhost6.localdomain6> <alpine.LFD.2.00.1102111359580.31804@localhost6.localdomain6> <20110211135906.GA16358@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1375176427-1297434372=:31804"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1375176427-1297434372=:31804
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 11 Feb 2011, Ingo Molnar wrote:
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> >  129 files changed, 4353 insertions(+), 5400 deletions(-)
> 
> Did I get the file count right - roughtly how many files are affected throughout all 
> architectures? The changes are massively intrusive and widely spread out so we 
> cannot do them in one go, right?

Alone the stuff which fiddles in irq_desc->status for whatever reasons
is >100 files in arch/. And that has do be done manually case by case.

The namespace cleanup affects about 300 files in arch, but that can be
done in one go right after -rc1 if I manage to get the regex straight :)

Thanks,

	tglx
---1463795968-1375176427-1297434372=:31804--
