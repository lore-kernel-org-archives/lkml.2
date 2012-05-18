Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966970Ab2ERMDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 08:03:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36720 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965342Ab2ERMDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 08:03:14 -0400
Date: Fri, 18 May 2012 14:03:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: hpa@zytor.com, satoru.moriya@hds.com, linux-kernel@vger.kernel.org,
        seiji.aguchi@hds.com, tony.luck@intel.com,
        dle-develop@lists.sourceforge.net, tglx@linutronix.de,
        dzickus@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/debug] kdump: Execute kmsg_dump(KMSG_DUMP_PANIC) after
 smp_send_stop()
Message-ID: <20120518120307.GC19785@gmail.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2E4D7A5CE2@USINDEVS01.corp.hds.com>
 <tip-f80f749132165fb083865e51afd65cf0f05dcd62@git.kernel.org>
 <1337340419.573.32.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337340419.573.32.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2012-05-18 at 03:49 -0700, tip-bot for Seiji Aguchi wrote:
> 
> > kdump: Execute kmsg_dump(KMSG_DUMP_PANIC) after smp_send_stop()
> > 
> > This patch moves kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop(),
> > to serialize the crash-logging process via smp_send_stop() and to
> > thus retrieve a more stable crash image of all CPUs stopped.
> 
> I don't want to be a spoil sport or anything, but this patch doesn't
> move anything, it just removes..

Hm, indeed. And the patch in the email is fine. I think I messed 
up a conflict resolution ...

Should be fixed now.

Thanks,

	Ingo
