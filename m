Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab2IUTy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:54:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53222 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861Ab2IUTy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:54:26 -0400
MIME-Version: 1.0
In-Reply-To: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 21 Sep 2012 12:54:04 -0700
X-Google-Sender-Auth: MEqibh-f_ngu0mS15JFFj1sYd6w
Message-ID: <CA+55aFwaZdMxLA1VCfOy9BDQHPp6CTwRFHYGUCXdJ4+KkQoN+g@mail.gmail.com>
Subject: Re: [PATCH 00/11] x86: Supervisor Mode Access Prevention
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 12:43 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> Supervisor Mode Access Prevention (SMAP) is a new security feature
> disclosed by Intel in revision 014 of the Intel® Architecture
> Instruction Set Extensions Programming Reference:

Looks good.

Did this find any bugs, btw? We've had a few cases where we forgot to
use the proper user access function, and code just happened to work
because it all boils down to the same thing and never got any page
faults in practice anyway..

I'd obviously hope that we have caught all of them, but.. IOW, has
SMAP actually triggered for anybody in testing inside Intel?

                 Linus
