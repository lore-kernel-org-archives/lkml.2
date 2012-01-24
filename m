Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab2AXRe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 12:34:58 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50508 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756912Ab2AXRe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 12:34:57 -0500
X-Sasl-enc: ln5YCGUvgAWtmTjWmTQspZT+OxOM+Iu1XAbWwzBSbrtW 1327426496
Subject: Re: [PATCH v3] sysctl: control functionality of /proc/pid/mem
From: Colin Walters <walters@verbum.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Borislav Petkov <bp@alien8.de>,
        Vasiliy Kulikov <segoon@openwall.com>, Dan Ballard <dan@mindstab.net>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Stephen Wilson <wilsons@start.ca>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-doc@vger.kernel.org
Date: Tue, 24 Jan 2012 12:34:33 -0500
In-Reply-To: <20120123212115.GA29641@www.outflux.net>
References: <20120123212115.GA29641@www.outflux.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1327426475.17382.3.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-23 at 13:21 -0800, Kees Cook wrote:
> Add the "proc_pid_mem" sysctl to control whether or not /proc/pid/mem is
> allowed to work: 0: disabled, 1: read only, 2: read/write (default).

Both your git commit and the Documentation/ entry are totally missing a
rationale for this.  Why would an admin want to set this on or off?
What replaces it, if anything?  What are the tradeoffs with its
replacement?  What userspace programs might break when this is toggled?


