Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab2FHNEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:04:54 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49393 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903Ab2FHNEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:04:52 -0400
MIME-Version: 1.0
In-Reply-To: <130cc6e8-9077-455a-9e88-3a7b5cde8aff@zmail13.collab.prod.int.phx2.redhat.com>
References: <20120607193747.GH21339@redhat.com>
	<130cc6e8-9077-455a-9e88-3a7b5cde8aff@zmail13.collab.prod.int.phx2.redhat.com>
Date: Fri, 8 Jun 2012 21:04:50 +0800
Message-ID: <CAJd=RBAMWejBbHvBk5a_9vyL2MzTSpBqhOR8pM4uW3wRY17hSw@mail.gmail.com>
Subject: Re: AutoNUMA15
From: Hillf Danton <dhillf@gmail.com>
To: Zhouping Liu <zliu@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 2:09 PM, Zhouping Liu <zliu@redhat.com> wrote:
>
> I have tested the kernel after removing the two commit 74a5ce20e6ee & 8e7fbcbc22c1241,
> but unluckily, the panic is still alive, so I think it's maybe not
> related to the two commit, and I will do more investigating to check
>

I see three reverts at

http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=log;h=refs/heads/autonuma

74a5ce20e Revert "sched: Fix SD_OVERLAP"
9f646389a Revert "sched/x86: Use cpu_llc_shared_mask(cpu) for coregroup_mask"
8e7fbcbc2 Revert "sched: Remove stale power aware scheduling remnants and
			dysfunctional knobs"

Would you please take revert of 9f646389a also into account?

Good Weekend
Hillf
