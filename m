Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab2IUUIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:08:53 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63981 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778Ab2IUUIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:08:51 -0400
Date: Fri, 21 Sep 2012 22:08:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 00/11] x86: Supervisor Mode Access Prevention
Message-ID: <20120921200846.GA25679@gmail.com>
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
 <CA+55aFwaZdMxLA1VCfOy9BDQHPp6CTwRFHYGUCXdJ4+KkQoN+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFwaZdMxLA1VCfOy9BDQHPp6CTwRFHYGUCXdJ4+KkQoN+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Sep 21, 2012 at 12:43 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> > Supervisor Mode Access Prevention (SMAP) is a new security 
> > feature disclosed by Intel in revision 014 of the Intel® 
> > Architecture Instruction Set Extensions Programming 
> > Reference:
> 
> Looks good.
> 
> Did this find any bugs, btw? We've had a few cases where we 
> forgot to use the proper user access function, and code just 
> happened to work because it all boils down to the same thing 
> and never got any page faults in practice anyway..

The 4g:4g patch sweeped out most of the historic ones - so what 
we have are perhaps newer bugs (but those should be pretty rare, 
most new features are cross-arch).

Thanks,

	Ingo
