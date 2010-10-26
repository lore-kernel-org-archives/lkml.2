Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962Ab0JZPtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:49:25 -0400
Received: from www.tglx.de ([62.245.132.106]:47020 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076Ab0JZPtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:49:23 -0400
Date: Tue, 26 Oct 2010 17:48:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
cc: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: Clocksource tsc unstable (delta = -8589361717 ns) in current
 git
In-Reply-To: <20101026135808.GB1672@arch.trippelsdorf.de>
Message-ID: <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6>
References: <20101026112052.GA1672@arch.trippelsdorf.de> <20101026131843.GC17852@aftab> <20101026135808.GB1672@arch.trippelsdorf.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, Markus Trippelsdorf wrote:
> On Tue, Oct 26, 2010 at 03:18:43PM +0200, Borislav Petkov wrote:
> > otherwise, I don't see anything strange in your dmesg. Unless tglx has a
> > better idea, I'd ask you to bisect it. 5618 changesets shouldn't be that
> > much but I don't know, if the issue appears every several hours it could
> > still be tedious.
> 
> That would be a several week long process, as the issue appears ~ every
> 2 days here on this machine running 24/7.

There is only a single commit in that area post 2.6.36:

      8af3c153baf95374eff20a37f00c59a295b52756 

But I have a hard time how this should make this happen. John ?

Thanks,

	tglx
