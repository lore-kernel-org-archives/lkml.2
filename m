Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab1GPNGP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 09:06:15 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:60522 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab1GPNGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 09:06:11 -0400
Date: Sat, 16 Jul 2011 09:05:55 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Greg KH <gregkh@suse.de>
Cc: Mike Waychison <mikew@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Kconfig: Allow disabling of CONFIG_DEVPORT
Message-ID: <20110716130555.GC29946@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Greg KH <gregkh@suse.de>,
	Mike Waychison <mikew@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org
References: <1310675693-9204-1-git-send-email-mikew@google.com>
 <20110714212113.GA28639@suse.de>
 <CAGTjWtB53vW5B2EJ5=+C3buDAY0RtsfANxx5NhC5aWnmEx08EQ@mail.gmail.com>
 <20110715064147.GA1021@suse.de>
 <C70E3912-6AA9-4EB3-85CC-11BF90D230C8@mit.edu>
 <20110715145132.GA4296@suse.de>
 <20110715185519.GI8453@thunk.org>
 <20110716075600.GA17945@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110716075600.GA17945@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 09:56:00AM +0200, Greg KH wrote:
> 
> If you want to propose, and document, using "Company-bug-id", that's
> great, and is valid, but don't try to slip things in like this, with a
> company specific name, into the standardized tag area and claim it is
> acceptable after the fact.
> 
> Again, I think people here are somehow forgetting the 300+ different
> companies that contribute to the kernel...

I've been doing this for several years, and there have been times when
I've put in Bugzilla references to both RedHat *and* SuSE bugs that
were closed due to customer confidential information.  I had access
because of NDA's signed between IBM and the enterprise distro's, and
the release engineers at both distro's seemed to be happy that I did
this.  In some cases I didn't have access to the bugzilla entry in
question, but I added the reference out of courtesy to the help desk
folks at the distro in question so they could more easily track the
fix as it travelled upstream to Linus and to various other derivitive
kernels, including the stable kernel series.

This is not new.  I've tended not to put it in the signed-off-block,
so when I've done it it's just been part of the commit description.

If it eases friction to some subset of the people who are using the
kernel, especially to people who helped me debug a problem in ext3,
ext4, e2fsprogs, etc., it seems like it's just common courtesy to
include a single line so the bugfix can be more easily tracked.  If
they helped me, I should help them.

I certainly don't plan to change this for anything for which I'm the
maintainer, and I would encourage other maintainers to do the same.

    	  		  		       - Ted

