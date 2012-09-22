Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab2IVLce (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 07:32:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35694 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab2IVLcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 07:32:32 -0400
Date: Sat, 22 Sep 2012 13:32:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 00/11] x86: Supervisor Mode Access Prevention
Message-ID: <20120922113226.GA3257@gmail.com>
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
 <20120921220818.GA30959@redhat.com>
 <505CE5C8.80007@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505CE5C8.80007@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@linux.intel.com> wrote:

> On 09/21/2012 03:08 PM, Dave Jones wrote:
> > 
> > Perhaps add a printk somewhere to show that it's actually been enabled maybe ?
> > 
> > Also, would it be feasible to add something like we have for test_nx ?
> > If this feature regresses in some way in the future, I suspect we'd like
> > to know about it sooner rather than later.
> > 
> 
> Good idea... should add this both for SMEP and SMAP.

Very much agreed - these exploit preventation hardware features 
are really useful, and it's good to inform the user that they 
are active.

Thanks,

	Ingo
