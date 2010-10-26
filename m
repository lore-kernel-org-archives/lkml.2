Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab0JZSEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 14:04:05 -0400
Received: from smtp-out-226.synserver.de ([212.40.180.226]:1306 "HELO
	smtp-out-225.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S933225Ab0JZSED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 14:04:03 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 23003
Date: Tue, 26 Oct 2010 19:56:39 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: Clocksource tsc unstable (delta = -8589361717 ns) in current
 git
Message-ID: <20101026175639.GF1637@arch.trippelsdorf.de>
References: <20101026112052.GA1672@arch.trippelsdorf.de>
 <20101026131843.GC17852@aftab>
 <20101026135808.GB1672@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 05:48:41PM +0200, Thomas Gleixner wrote:
> On Tue, 26 Oct 2010, Markus Trippelsdorf wrote:
> > On Tue, Oct 26, 2010 at 03:18:43PM +0200, Borislav Petkov wrote:
> > > otherwise, I don't see anything strange in your dmesg. Unless tglx has a
> > > better idea, I'd ask you to bisect it. 5618 changesets shouldn't be that
> > > much but I don't know, if the issue appears every several hours it could
> > > still be tedious.
> > 
> > That would be a several week long process, as the issue appears ~ every
> > 2 days here on this machine running 24/7.
> 
> There is only a single commit in that area post 2.6.36:
> 
>       8af3c153baf95374eff20a37f00c59a295b52756 

There is also: acf01734b1747b1ec4be6f159aff579ea5f7f8e2
but I'm not sure if this commit is really relevant.

-- 
Markus
