Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab2JORTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:19:33 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39333 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab2JORTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:19:30 -0400
Date: Mon, 15 Oct 2012 22:49:32 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>, oleg@redhat.com
Subject: Re: [PATCH 1/9] uprobes: move function declarations out of arch
Message-ID: <20121015171932.GA28723@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1350242593-17761-1-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1350242593-17761-1-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101517-1976-0000-0000-0000126213CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rabin Vincent <rabin@rab.in> [2012-10-14 21:23:05]:

> It seems odd to keep the function declarations in the arch header where
> they will need to be copy/pasted verbatim across arches.  Move them to
> the common header.
> 



> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  arch/x86/include/asm/uprobes.h |    6 ------
>  include/linux/uprobes.h        |    8 ++++++++
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 

You need to take care of the powerpc port
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=8b7b80b9ebb46dd88fbb94e918297295cf312b59

Also as Oleg pointed out, He has already posted changes on top of -tip.
So it probably makes sense to redo these patches on top of those
patches.

-- 
Thanks and Regards
Srikar

