Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab2GPSqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 14:46:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab2GPSq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 14:46:26 -0400
Date: Mon, 16 Jul 2012 14:46:11 -0400
From: Dave Jones <davej@redhat.com>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jiri Kosina <jkosina@suse.cz>, Darren Hart <dvhart@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, a.p.zijlstra@chello.nl
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 0000000000000010 on 3.5-rc6
Message-ID: <20120716184611.GA16422@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"devendra.aaru" <devendra.aaru@gmail.com>,
	richard -rw- weinberger <richard.weinberger@gmail.com>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Jiri Kosina <jkosina@suse.cz>, Darren Hart <dvhart@linux.intel.com>,
	Kees Cook <keescook@chromium.org>, a.p.zijlstra@chello.nl
References: <CAHdPZaM8Vnfkkon_vCF-jPQLq6WH482ozhH3U08hF30bOMr7Ow@mail.gmail.com>
 <CAFLxGvzkx6e19Gj=vKj3yjW3Yjj3eBx1SbGkmdbTMK6WMtX5Bg@mail.gmail.com>
 <CAHdPZaM3Xq9=HLJztQe2hW7mxwatYeeUV7AKnCEr0xzpTJwQRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHdPZaM3Xq9=HLJztQe2hW7mxwatYeeUV7AKnCEr0xzpTJwQRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 09:18:04PM +0545, devendra.aaru wrote:
 > On Sat, Jul 14, 2012 at 8:07 PM, richard -rw- weinberger
 > <richard.weinberger@gmail.com> wrote:
 > > On Sat, Jul 14, 2012 at 2:11 PM, devendra.aaru <devendra.aaru@gmail.com> wrote:
 > >> 3.5-rc6 with git head at fdb1335a82e. (from Torvald's branch)
 > >
 > > CC'in futex guys...
 > >
 > >> dmesg:
 > >>
 > >> [43610.535421] BUG: unable to handle kernel NULL pointer dereference
 > >> at 0000000000000010
 > >
 > > Is this the first error message in dmesg?
 > No its not. and i was doing a dmesg -c and run... thats bad i should
 > not be doing that..
 > > IOW no WARNING before the BUG?
 > yeah there were some warnings about the trinity.
 > >
 > > Looks like futex_wait_requeue_pi() was called before  pi_state->pi_mutex got
 > > initialized.
 > >
 > 
 > Let me reproduce it again... and i will report it with full dmesg again.

Check the bugs-found.txt file in trinity.git before reporting bugs found with it.
This one already got reported.. https://lkml.org/lkml/2012/7/13/328
I try to keep that file up to date to reduce multiple reports of the same bug.
(also, for that reason, please cc me on bugs you find with it!)

thanks,

	Dave
