Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab2C0Qm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:42:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63908 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2C0Qmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:42:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6661"; a="176220009"
Date: Tue, 27 Mar 2012 11:42:53 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Linas Vepstas <linas@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/20] hexagon/mm/vm_fault.c: Port OOM changes to
 do_page_fault
Message-ID: <20120327164253.GB3916@codeaurora.org>
References: <1332249813-2970-1-git-send-email-consul.kautuk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332249813-2970-1-git-send-email-consul.kautuk@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 09:23:33AM -0400, Kautuk Consul wrote:
> Commit d065bd810b6deb67d4897a14bfe21f8eb526ba99
> (mm: retry page fault when blocking on disk transfer) and
> commit 37b23e0525d393d48a7d59f870b3bc061a30ccdb
> (x86,mm: make pagefault killable)
> 
> The above commits introduced changes into the x86 pagefault handler
> for making the page fault handler retryable as well as killable.
> 
> These changes reduce the mmap_sem hold time, which is crucial
> during OOM killer invocation.
> 
> Port these changes to hexagon.
> 
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> ---
>  arch/hexagon/mm/vm_fault.c |   22 +++++++++++++++++-----
>  1 files changed, 17 insertions(+), 5 deletions(-)
> 

Sorry for the delay; got around to it this morning.  Looks good; thanks!

Acked-by: Richard Kuo <rkuo@codeaurora.org>


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
