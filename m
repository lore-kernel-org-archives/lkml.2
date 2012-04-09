Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab2DIVdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:33:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab2DIVdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:33:47 -0400
Date: Mon, 9 Apr 2012 14:33:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: shuahkhan@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH v5] ramoops: use pstore interface
Message-Id: <20120409143345.a7a8c257.akpm@linux-foundation.org>
In-Reply-To: <CAGXu5jL-QP6LUqc_JY-JevNbrsRUpiP337pfUH4m1CA-+jm_RQ@mail.gmail.com>
References: <20120117235852.GA4877@www.outflux.net>
	<20120118140603.0fc22302.akpm@linux-foundation.org>
	<CAGXu5jKiPaChjvjA7r12mSH2W0r-X4EdFpQMMMaBOL+C=3UftA@mail.gmail.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2DA7A7F226@USINDEVS01.corp.hds.com>
	<4F1A7854.7010808@gmail.com>
	<1333399194.6431.3.camel@lorien2>
	<CAGXu5jL-QP6LUqc_JY-JevNbrsRUpiP337pfUH4m1CA-+jm_RQ@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2012 13:51:29 -0700
Kees Cook <keescook@chromium.org> wrote:

> On Mon, Apr 2, 2012 at 1:39 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
> >> First of all ramoops was born mainly for debug purpose and to help the
> >> maintainability of a product. I used it in systems where the uptime (so
> >> no reboot) was important. So it can be very useful for me load the
> >> module, gather logs and unload it for example. A kernel panic is not
> >> recoverable so the reboot is needed but it's not always true for a
> >> kernel oops.
> >>
> >> Marco
> >
> > What is the status of this patch? Don't see it in 3.3 and haven't
> > checked 3.4-rc1 yet.
> 
> Hi,
> 
> I've been hoping it would get into 3.4. It's in the -mm tree, and has
> been living in linux-next for a while. I'm not sure why it hasn't been
> merged into Linus's tree yet. Andrew, is there a reason it hasn't been
> merged?

The patch breaks ramoops module unloading.  Tony says there's "no
credible end-user case" for this and Marco promptly provided one,
which was ignored.

