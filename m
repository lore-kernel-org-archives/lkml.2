Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2C0NFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 09:05:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:33564 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab2C0NFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 09:05:19 -0400
Date: Tue, 27 Mar 2012 15:05:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tony Luck <tony.luck@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 4/4] ia64: vsyscall: Use seqcount instead of seqlock
In-Reply-To: <CA+8MBbK5J_1veoDwGNNZrmjJqAhxEQCC3JPSp36sMSRnr6y-4w@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1203271502300.2542@ionos>
References: <20120228194200.180923135@linutronix.de> <20120228194508.624811514@linutronix.de> <CA+8MBbK5J_1veoDwGNNZrmjJqAhxEQCC3JPSp36sMSRnr6y-4w@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-947994331-1332853518=:2542"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-947994331-1332853518=:2542
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 26 Mar 2012, Tony Luck wrote:

> >        /* used by fsys_gettimeofday in arch/ia64/kernel/fsys.S */
> > -       DEFINE(IA64_GTOD_LOCK_OFFSET,
> > -               offsetof (struct fsyscall_gtod_data_t, lock));
> > +       DEFINE(IA64_GTOD_SEQ_OFFSET,
> > +               offsetof (struct fsyscall_gtod_data_t, seq);
> 
> Thomas,
> 
> Could you spare one more ")" here please? The compiler likes
> it if they match :-)

Duh, crap. /me rumages for an ia64 compiler

--8323328-947994331-1332853518=:2542--
