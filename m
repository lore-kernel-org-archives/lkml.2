Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759740Ab1FAVXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 17:23:50 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57005 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757259Ab1FAVXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 17:23:49 -0400
Date: Wed, 1 Jun 2011 14:23:30 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu, rostedt@goodmis.org,
        jmorris@namei.org, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 05/13] seccomp_filter: Document what seccomp_filter is
 and how it works.
Message-ID: <20110601212330.GF19633@outflux.net>
References: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
 <1306897845-9393-5-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306897845-9393-5-git-send-email-wad@chromium.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

Minor typo corrections below...

On Tue, May 31, 2011 at 10:10:37PM -0500, Will Drewry wrote:
>  Adds a text file covering what CONFIG_SECCOMP_FILTER is, how it is
>  implemented presently, and what it may be used for.  In addition,
>  the limitations and caveats of the proposed implementation are
>  included.
> 
> --- /dev/null
> +++ b/Documentation/prctl/seccomp_filter.txt
> @@ -0,0 +1,145 @@
> ...
> +certain subset of userland applications benefit by having a reduce set
                                                               reduced

> +of available system calls.  The reduced set reduces the total kernel

Maybe "The resulting set reduces ... " ?


-Kees

-- 
Kees Cook
Ubuntu Security Team
