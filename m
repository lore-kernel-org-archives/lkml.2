Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030254Ab2GKUxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 16:53:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65535 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030191Ab2GKUxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 16:53:45 -0400
Date: Wed, 11 Jul 2012 13:53:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: linux-kernel@vger.kernel.org
cc: mm-commits@vger.kernel.org, alan@linux.intel.com
Subject: Re: + kernel-sysc-fix-mishandling-of-out-of-memory-in-poweroff.patch
 added to -mm tree
In-Reply-To: <20120710201118.7F54420004E@hpza10.eem.corp.google.com>
Message-ID: <alpine.DEB.2.00.1207111352520.3635@chino.kir.corp.google.com>
References: <20120710201118.7F54420004E@hpza10.eem.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2012, akpm@linux-foundation.org wrote:

> 
> The patch titled
>      Subject: kernel/sys.c: fix mishandling of out of memory in poweroff
> has been added to the -mm tree.  Its filename is
>      kernel-sysc-fix-mishandling-of-out-of-memory-in-poweroff.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Alan Cox <alan@linux.intel.com>
> Subject: kernel/sys.c: fix mishandling of out of memory in poweroff
> 
> Coverity 703573
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Cong Wang proposed the same patch a week ago (with a changelog!), so there 
are some acks you can add to this.

http://marc.info/?t=134137312200002
