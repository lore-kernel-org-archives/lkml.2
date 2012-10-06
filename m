Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258Ab2JFXGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 19:06:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46556 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab2JFXGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 19:06:04 -0400
Date: Sun, 7 Oct 2012 01:05:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: danielfsantos@att.net
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Santos <daniel.santos@pobox.com>
Subject: Re: [PATCH v2 03/10] compiler-gcc{3,4}.h: Use GCC_VERSION macro
Message-ID: <20121006230559.GA3278@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, danielfsantos@att.net,
	LKML <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christopher Li <sparse@chrisli.org>,
	David Daney <david.daney@cavium.com>,
	David Howells <dhowells@redhat.com>,
	David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Pavel Pisa <pisa@cmp.felk.cvut.cz>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Steven Rostedt <rostedt@goodmis.org>,
	Daniel Santos <daniel.santos@pobox.com>
References: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
 <1349466169-20637-3-git-send-email-daniel.santos@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1349466169-20637-3-git-send-email-daniel.santos@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 02:42:42PM -0500, danielfsantos@att.net wrote:
> Using GCC_VERSION reduces complexity, is easier to read and is GCC's
> recommended mechanism for doing version checks. (Just don't ask me why
> they didn't define it in the first place.)  This also makes it easy to
> merge compiler-gcc{,3,4}.h should somebody want to.
> 
> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> Acked-by: David Rientjes <rientjes@google.com>

Looks correct to me:

Acked-by: Borislav Petkov <bp@alien8.de>

Thanks.

-- 
Regards/Gruss,
    Boris.
