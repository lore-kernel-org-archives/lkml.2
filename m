Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab0GSGhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 02:37:40 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55632 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab0GSGhj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 02:37:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ueWqWzOmgTLnQaj8D6+fM/PeoSeBANfnUO/7S+HR0mvWE/yn6L947xt9X0M0Lyh/BB
         sCcQpgVSaKSpJyFdlznNbRKnwJSiTPMXi79QZCV8evp1aPY130v+Xww2qWAm3r66I6YT
         lf28Qf/SpAHnL7kwd23P9G31kjl+2BrLI8mmw=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1007131745230.3321@localhost.localdomain>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain> 
	<alpine.LFD.2.00.1002262041020.4245@localhost.localdomain> 
	<alpine.LFD.2.00.1003121124120.22855@localhost.localdomain> 
	<alpine.LFD.2.00.1003211158130.3147@localhost.localdomain> 
	<alpine.LFD.2.00.1004071619490.32352@localhost.localdomain> 
	<alpine.LFD.2.00.1004271744280.2951@localhost.localdomain> 
	<alpine.LFD.2.00.1004301156590.2951@localhost.localdomain> 
	<alpine.LFD.2.00.1005022109150.25342@localhost.localdomain> 
	<alpine.LFD.2.00.1006091837410.2933@localhost.localdomain> 
	<alpine.LFD.2.00.1007131745230.3321@localhost.localdomain>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 19 Jul 2010 14:37:18 +0800
Message-ID: <AANLkTikWbQQC5ubR3JrCx_PlFJWGsoxGmldswwatgwVQ@mail.gmail.com>
Subject: Re: [ANNOUNCE] 2.6.33.6-rt26
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
Just want to know when there will be released RT patch for 2.6.34? We
have some tasks to patch RT to our local 2.6.34 tree.
Thanks
Barry

On Tue, Jul 13, 2010 at 11:54 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> We are pleased to announce the next update to our new preempt-rt
> series.
>
> Changes from 2.6.33.5-rt23 to 2.6.33.5-rt24:
>
>  42edbcb: gianfar: Fix TX ring processing on SMP machines
>  faf3581: timer_stats: Convert table_lock to raw_spin_lock
>  654e404: hvc_console: Fix race between hvc_close and hvc_remove
>  09fd768: hvc_console: Fix race between hvc_close and hvc_remove
>  ea2d2a0: perf: Fix errors path in perf_output_begin()
>  60bd946: KEYS: find_keyring_by_name() can gain access to a freed keyring
>  b5ac516: tracing: Update the comm field in the right variable in update_max_tr
>  77cb7c1: lockdep: Reduce stack_trace usage
>  cee9ee0: powerpc: Disable sparse irq for RT
>  c7dec16: powerpc: Enable interrupts in do_signal()
>
> Changes from 2.6.33.5-rt24 to 2.6.33.5-rt25:
>
>  ec646ea: vfs: Revert the scalability patches
>
> Changes from 2.6.33.5-rt26 to 2.6.33.6-rt26:
>
>  7e1af11: Merge git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.33.y
>
> Bulk of changes comes from the stable tree and from the big revert of
> the VFS scalability patches. They looked promising, but the nasty
> details bit us hard. We'll revisit them later.
>
> There are some pending issues:
>      - rtc_lock suspend/resume (working on a patch)
>      - futex requeue_pi (patch available, needs testing/confirmation)
>      - powerpc64 oddities (patch available, needs rework)
>
> Download locations:
>
>   http://www.kernel.org/pub/linux/kernel/projects/rt/
>
> Git release branch:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/2.6.33
>
> Gitweb:
>   http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.33
>
> Information on the RT patch can be found at:
>
>   http://rt.wiki.kernel.org/index.php/Main_Page
>
> To build the 2.6.33.6-rt26 tree, the following patches should be
> applied:
>
>   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.33.6.tar.bz2
>   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33.6-rt26.bz2
>
> Enjoy !
>
>      tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
