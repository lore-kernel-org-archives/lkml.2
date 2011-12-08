Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab1LHALs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:11:48 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48066 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab1LHALr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:11:47 -0500
Date: Thu, 8 Dec 2011 01:11:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 2/2] selftests: New x86 breakpoints selftest
Message-ID: <20111208001138.GD13252@somewhere.redhat.com>
References: <1322840475-19553-1-git-send-email-fweisbec@gmail.com>
 <1322840475-19553-2-git-send-email-fweisbec@gmail.com>
 <20111207153223.4885bab9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207153223.4885bab9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 03:32:23PM -0800, Andrew Morton wrote:
> On Fri,  2 Dec 2011 16:41:15 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Bring a first selftest in the relevant directory.
> 
> That all looks nice and simple, thanks.  Unless I get suitably shouted
> at I think I'll send all this Linuswards.  Then I can hassle people to
> add their little test snippets as they add userspace-visible features.
> 
> I don't think we'd ever want to turn this into some huge kernel
> verification suite.  My thinking here is that I frequently see that
> people have written little test cases for their new feature, but those
> test cases just die after the feature is merged.  It would be better to
> maintain and grow these tests as the relevant features are augmented or
> bugfixed.

Exactly. And I also think this is no good place for background long running
stress-tests but rather for correctness tests (Unless we find situations
where short stress-tests are enough to trigger correctness problems).
That's really targeted to spot ABI breakages or alike.

My selftest for the cgroup task counter subsystem is also a good candidate for
that (if that subsystem ever get merged but that's a separate debate ;)

> 
> All these features are Linux-specific.  Standard interface features (eg
> POSIX) are and should be tested via other externally-maintained test
> suites.
> 
> If the whole idea ends up not working out, we can just delete it all.

Agreed, let the selftest subsystem selftest itself for a while and we'll figure
out.

Thanks.
