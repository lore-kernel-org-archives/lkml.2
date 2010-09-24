Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab0IXRaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:30:00 -0400
Received: from www.tglx.de ([62.245.132.106]:53922 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab0IXR36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 13:29:58 -0400
Date: Fri, 24 Sep 2010 19:31:07 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/5] uio hotplug support
Message-ID: <20100924173106.GA4966@silverbox.local>
References: <m1y6b48973.fsf@fess.ebiederm.org>
 <20100917205946.GF2522@local>
 <m139t451b4.fsf_-_@fess.ebiederm.org>
 <20100924104555.GC1819@silverbox.local>
 <m1hbhfcbdo.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hbhfcbdo.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 10:14:11AM -0700, Eric W. Biederman wrote:
> "Hans J. Koch" <hjk@linutronix.de> writes:
> 
> > On Mon, Sep 20, 2010 at 12:19:59AM -0700, Eric W. Biederman wrote:
> >> 
> >> Implement the ability to hotunplug a uio device while file handles
> >> are still open without crashing.
> >
> > Could you please create patches that apply on top of your already
> > accepted UIO changes?
> 
> That is what the patches I sent should be.  My apologies if I had not
> made that clear.  Certainly these patches were built against my previous
> changes, on top of 2.6.36-rc4.  Are you having problems?

Hmm, I applied your first series of 5 patches (which I signed-off). When
trying to apply your second series, I get this from quilt:

Applying patch 2_1-Simplify-the-lifetime-logic-of-struct-uio_device.patch
patching file drivers/uio/uio.c
Hunk #2 succeeded at 287 (offset 8 lines).
Hunk #3 succeeded at 312 (offset 8 lines).
Hunk #4 FAILED at 339.
Hunk #5 succeeded at 806 (offset 17 lines).
Hunk #6 FAILED at 831.
Hunk #7 FAILED at 858.
Hunk #8 FAILED at 889.
4 out of 8 hunks FAILED -- rejects in file drivers/uio/uio.c
Patch 2_1-Simplify-the-lifetime-logic-of-struct-uio_device.patch does not apply (enforce with -f)

The first series applied without any fuzz against 2.6.36-rc5.

Thanks,
Hans

> 
> If necessary I can grab Greg's tree can rebase my patches onto it.
> 
> Eric
