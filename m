Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab0C3TeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 15:34:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:33498 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab0C3TeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 15:34:07 -0400
Message-ID: <4BB251EB.5010008@windriver.com>
Date: Tue, 30 Mar 2010 14:32:59 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Martin Hicks <mort@sgi.com>
Subject: Re: linux-next: build failure after merge of the slabh tree
References: <20100329160248.e15e7836.sfr@canb.auug.org.au>
In-Reply-To: <20100329160248.e15e7836.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Mar 2010 19:32:58.0426 (UTC) FILETIME=[CD9791A0:01CAD03F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 12:02 AM, Stephen Rothwell wrote:
> Hi Tejun,
>
> After merging the slabh tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> kernel/debug/kdb/kdb_support.c: In function 'kdb_strdup':
> kernel/debug/kdb/kdb_support.c:309: error: implicit declaration of function 'kmalloc'
> kernel/debug/kdb/kdb_support.c:309: warning: initialization makes pointer from integer without a cast
> kernel/debug/kdb/kdb_support.c: In function 'debug_kfree':
> kernel/debug/kdb/kdb_support.c:810: error: implicit declaration of function 'kfree'
>
> Caused by commit d103d3b3e8512312b5254950035366d4422a479a ("percpu: don't
> implicitly include slab.h from percpu.h") from the slabh tree interacting
> with commit 5572dd736e5577dfefafe2ad3b54760e8323e33d ("kdb: core for kgdb
> back end (1 of 2)") from the kgdb tree.
>
> I applied the following merge fixup patch which should be applied to the
> kdbg tree (see Documentation/SubmitChecklist Rule #1 :-)).
>
>   

But of course.

This is applied and will appear in kgdb-next in the next hour.

Thanks,
Jason.
