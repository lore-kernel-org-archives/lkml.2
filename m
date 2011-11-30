Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab1K3LSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 06:18:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:57144 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216Ab1K3LR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 06:17:57 -0500
Message-ID: <1322651859.2921.249.camel@twins>
Subject: Re: [PATCH] sched: Proper initialization of root_task_group
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Heechul Yun <heechul@illinois.edu>
Cc: pjt@google.com, linux-kernel@vger.kernel.org
Date: Wed, 30 Nov 2011 12:17:39 +0100
In-Reply-To: <20111130054227.GA7808@heechul-desktop>
References: <20111130054227.GA7808@heechul-desktop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 23:42 -0600, Heechul Yun wrote:
> Hi,
> 
> The following patch fix a initialization issue.
> 
> Thanks
> 
> Heechul
> 
> ---
> The root_task_group.cfs_bandwidth and root_task_group.shares
> were initialized multiple times unnecessarily which are corrected
> by this patch.

The changelog and you comment above contradict each other. Multiple
initialization isn't a bug, therefore there isn't anything an issue as
such and nothing to 'fix'.

Anyway, the patch adds #ifdeffery, I really rather prefer the double
init over more #ifdeffery.

If you can sort it without introducing more #ifdeffery, or rather, even
reduce the #ifdeffery, I'll take it.

