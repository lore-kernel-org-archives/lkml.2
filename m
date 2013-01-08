Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab3AHXnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:43:37 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:44218 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009Ab3AHXne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:43:34 -0500
MIME-Version: 1.0
In-Reply-To: <1357195653-998-2-git-send-email-vgupta@synopsys.com>
References: <50D2B75A.3000208@synopsys.com>
	<1357195653-998-1-git-send-email-vgupta@synopsys.com>
	<1357195653-998-2-git-send-email-vgupta@synopsys.com>
Date: Tue, 8 Jan 2013 15:43:32 -0800
X-Google-Sender-Auth: Nbex-AwcBVxoWrXqieas55dhHBg
Message-ID: <CA+8MBbKk0Gd98KBxPY9QNw7wHGAEx8K6+iKzxDAcO-s7Py9_HA@mail.gmail.com>
Subject: Re: [RESEND PATCH] sysctl: Enable IA64 "ignore-unaligned-usertrap" to
 be used cross-arch
From: Tony Luck <tony.luck@intel.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 10:47 PM, Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:

> verbosw warnings on unaligned access emaultion.
"verbose", "emulation"

> While the exact menchaincs (ignore/shout) are still arch specific, we
"mechanics"

> +config SYSCTL_ARCH_UNALIGN_NO_WARN
> +       bool
> +       help
> +         Enable support for /proc/sys/kernel/ignore-unaligned-usertrap
> +         Allows arch to define/use @no_unaligned_warning to possbly warn about
"possibly"
> +         unaligned access emulation going on under the hood.
> +         see arch/ia64/kernel/unaligned.c for reference

It doesn't seem right to point users at an ia64 specific file now
that you are making this available to all arches.

-Tony
