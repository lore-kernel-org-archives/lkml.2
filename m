Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab2JWUQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:16:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39075 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467Ab2JWUQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:16:47 -0400
Date: Tue, 23 Oct 2012 13:16:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 001/193] make CONFIG_EXPERIMENTAL invisible and default
Message-ID: <20121023201643.GG3408@kroah.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-2-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351022666-6960-2-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 01:01:14PM -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default (especially in distro builds). As agreed
> during the Linux kernel summit, it should be removed. As a first step,
> remove it from being listed, and default it to on. Once it has been
> removed from all subsystem Kconfigs, it will be dropped entirely.
> 
> For items that really are experimental, maintainers should use "default
> n", optionally include "(EXPERIMENTAL)" in the title, and add language to
> the help text indicating why the item should be considered experimental.
> 
> For items that are dangerously experimental, the maintainer is encouraged
> to follow the above title recommendation, add stronger language to the
> help text, and optionally use (depending on the extent of the danger,
> from least to most dangerous): printk(), add_taint(TAINT_WARN),
> add_taint(TAINT_CRAP), WARN_ON(1), and CONFIG_BROKEN.
> 
> CC: Greg KH <gregkh@linuxfoundation.org>
> CC: "Eric W. Biederman" <ebiederm@xmission.com>
> CC: Serge Hallyn <serge.hallyn@canonical.com>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  init/Kconfig |   31 ++-----------------------------
>  1 file changed, 2 insertions(+), 29 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

