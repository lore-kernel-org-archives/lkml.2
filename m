Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1GVIs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 04:48:27 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:64405 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab1GVIsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 04:48:25 -0400
Date: Fri, 22 Jul 2011 10:48:20 +0200
From: Tejun Heo <tj@kernel.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-next: manual merge of the ptrace tree with the s390 tree
Message-ID: <20110722084820.GG2622@htj.dyndns.org>
References: <20110720153320.a7f33784158ccb04fafcb5d6@canb.auug.org.au>
 <20110721080240.GZ3455@htj.dyndns.org>
 <20110721144447.GA7580@redhat.com>
 <20110722080600.GE2622@htj.dyndns.org>
 <20110722102922.61e7e279@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722102922.61e7e279@mschwide>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Martin.

On Fri, Jul 22, 2011 at 10:29:22AM +0200, Martin Schwidefsky wrote:
> I could special case ptrace with PTRACE_SINGLESTEP to return with
> TRAP_TRACE instead of TRAP_HWBKPT but that would be artificial.
> From the hardware perspective its the same.

It's true that ptrace is more dependent on arch details than most but
still part of user-facing API and maintaining API consistency should
haver higher priority, so I really think we should have well defined
generic set of event information all archs implement and then some
arch dependent exception where absolutely necessary.  The problem at
this stage tho is that I don't have much idea how to divide them.  Eh
well, let's see how it goes. :)

Thanks.

-- 
tejun
