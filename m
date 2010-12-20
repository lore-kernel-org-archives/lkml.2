Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab0LTNTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 08:19:54 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52285 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab0LTNTx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 08:19:53 -0500
Subject: Re: [tip:sched/core] sched: Add 'autogroup' scheduling feature:
 automated per session task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Bharata B Rao <bharata.rao@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, torvalds@linux-foundation.org,
        efault@gmx.de, pjt@google.com, markus@trippelsdorf.de,
        tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <AANLkTimRfVFmuMJzuirgsc37=RhC6zKX0C0YXhXO44O9@mail.gmail.com>
References: <1290281700.28711.9.camel@maggy.simson.net>
	 <tip-5091faa449ee0b7d73bc296a93bca9540fc51d0a@git.kernel.org>
	 <AANLkTimRfVFmuMJzuirgsc37=RhC6zKX0C0YXhXO44O9@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Dec 2010 14:19:19 +0100
Message-ID: <1292851159.5021.2.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 18:38 +0530, Bharata B Rao wrote:
> The autogroup patchset removes the display of cgroup name from
> sched_debug output. 

Hrmph.. that wasn't supposed to happen, care to send a patch to fix that
up?


> Also, with tg_shares_up improvements, the leaf cfs_rqs are maintained
> on rq->leaf_cfs_rq_list only if they carry any load. But the code to
> display cfs_rq information for sched_debug isn't updated and hence
> information from a few cfs_rqs are missing from sched_debug.

Well, that's a _good_ thing, right?

I mean, if we know they're empty, and don't contribute to schedule, why
bother displaying them?
