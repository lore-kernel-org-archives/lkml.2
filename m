Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab2JCX2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:28:47 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63860 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350Ab2JCX2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:28:46 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 3 Oct 2012 16:29:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: make CONFIG_EXPERIMENTAL invisible and default
Message-ID: <20121003232923.GA21374@roeck-us.net>
References: <20121002195042.GA16087@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002195042.GA16087@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 07:50:42PM -0000, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, it should be removed. As a first step, remove it from being
> listed, and default it to on. Once it has been removed from all
> subsystem Kconfigs, it will be dropped entirely.
> 
> CC: Greg KH <gregkh@linuxfoundation.org>
> CC: "Eric W. Biederman" <ebiederm@xmission.com>
> CC: Serge Hallyn <serge.hallyn@canonical.com>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> 
> ---
> This is the first of a series of 202 patches removing EXPERIMENTAL from
> all the Kconfigs in the tree. Should I send them all to lkml (with all
> the associated CCs), or do people want to cherry-pick changes from my
> tree? I don't want to needlessly flood the list.
> 
> http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/experimental
> 
I cherry-picked the hwmon/pmbus patch (commit 41c5b6bb).

Guenter
