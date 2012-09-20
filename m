Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2ITHgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:36:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59515 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2ITHgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:36:38 -0400
Date: Thu, 20 Sep 2012 09:36:24 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Andy Lutomirski <luto@amacapital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/6][RFC] Rework vsyscall to avoid truncation/rounding
 issue in timekeeping core
Message-ID: <20120920073624.GC2349@netboy.at.omicron.at>
References: <5057BE59.3050903@linaro.org>
 <20120918180200.GA2281@netboy.at.omicron.at>
 <5058BD9E.30909@linaro.org>
 <20120919045038.GA2248@netboy.at.omicron.at>
 <5059F367.5020104@linaro.org>
 <20120919170347.GA2232@netboy.at.omicron.at>
 <505A06BD.6000406@linaro.org>
 <CALCETrUAiLXvxYMnNDvdUSFkno+v+P_XGirOYch-k8dUG05jpw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F19D43167@ORSMSX108.amr.corp.intel.com>
 <505A34E6.6040107@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505A34E6.6040107@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 02:11:02PM -0700, John Stultz wrote:
> Now, I suspect the difficult part will be finding someone with the
> time and interest to try get the vdso gettime working on ia64 (or
> s390 or powerpc), and then try to unify the kernel side
> implementation. Reducing the maintenance burden might not be
> inspirational enough, especially if there is a small performance
> cost along with it.

Small performance cost verses correct time keeping?

I couldn't help but notice all of the leap second issues and fixes
that, once again, appeared this summer. It is great that John looks
after this stuff, but I cannot avoid the image of Hans Brinker
stopping leaks with his fingers.

There is a way to fix this issue once and for all (as we discussed
before). But in order to implement it, one would have to change all of
the vdsos, too. So if there is way to refactor the vdsos, then I see
this as a most "inspirational" task.

> And also, all this discussion is a bit far afield of the patchset
> I'm proposing here. :)  I'd still like to hear any thoughts on it
> from the various arch maintainers, otherwise I'll submit it to

(Sorry for the continuing off topic rant)

Thanks,
Richard
