Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab2JQVro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 17:47:44 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52100 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab2JQVrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 17:47:43 -0400
Date: Wed, 17 Oct 2012 14:47:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] RCU documentation: Correct the name of a reference
Message-ID: <20121017214736.GQ2385@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAPhKKr-c8ATOswuvxe+vBoLh6B-7VZSSiOkS5vbvzBCX7RLewA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhKKr-c8ATOswuvxe+vBoLh6B-7VZSSiOkS5vbvzBCX7RLewA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101721-8974-0000-0000-00000FB7372A
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00183356; UDB=6.00041534; UTC=2012-10-17
 21:47:41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 11:05:37AM -0400, Dhaval Giani wrote:
> [Attaching the patch as gmail breaks the patches]
> 
> Trying to go through the history of RCU (not for the weak
> minded) led me to search for a non-existent paper.
> 
> Correct it to the actual reference

Queued, thank you!

						Thanx, Paul

> Signed-off-by: Dhaval Giani <dhaval.giani@gmail.com>
> Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Index: linux/Documentation/RCU/RTFP.txt
> ===================================================================
> --- linux.orig/Documentation/RCU/RTFP.txt
> +++ linux/Documentation/RCU/RTFP.txt
> @@ -186,7 +186,7 @@ Bibtex Entries
> 
>  @article{Kung80
>  ,author="H. T. Kung and Q. Lehman"
> -,title="Concurrent Maintenance of Binary Search Trees"
> +,title="Concurrent Manipulation of Binary Search Trees"
>  ,Year="1980"
>  ,Month="September"
>  ,journal="ACM Transactions on Database Systems"


