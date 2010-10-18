Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab0JRCEf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 22:04:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53196 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab0JRCEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 22:04:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pn9q2E1C6uZMVL05k2S0C4BXvtPWoR/tMQnoq1JvclOBCo0jIYzScJpCO2B03XjuEA
         4yF9brIMwrJ9vAvQm/jw9skgV6MvWv0XT4bjUCwwZxSxIu2uRRlww3bP1drkgWpao7Yf
         /fg0fx9WAk4WDeEVybqwbEVrbCVmO96EVpMzI=
Date: Mon, 18 Oct 2010 04:04:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: 2.6.36-rc5-mmotm0928 BUG while trying to ptrace a process
Message-ID: <20101018020429.GB21722@nowhere>
References: <20101018102609.3ADF.A69D9226@jp.fujitsu.com> <20101018013622.GA21722@nowhere> <20101018104259.3AE5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018104259.3AE5.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 11:01:18AM +0900, KOSAKI Motohiro wrote:
> > On Mon, Oct 18, 2010 at 10:28:43AM +0900, KOSAKI Motohiro wrote:
> > > > On Wed, 2010-10-06 at 05:32 -0400, Valdis.Kletnieks@vt.edu wrote:
> > > > > Dell Latitude E6500,  Intel Core2 Duo P8700 CPU.
> > > > > 
> > > > > Have seen this three times now while trying to attach gdb to a hung Firefox
> > > > > process.
> > > > > 
> > > > > [20669.480674] BUG: unable to handle kernel NULL pointer dereference at 0000000000000100
> > > > > [20669.480682] IP: [<ffffffff810b8275>] __reserve_bp_slot+0x56/0x17d
> > > > 
> > > > Known issue I think, Frederic was looking into curing this.
> > > > 
> > > > Frederic, what's the current status of that?
> > > 
> > > mmotm1014 seems still have this issue. Frederic, can you please tell us
> > > current status if you are tracking this issue?
> > 
> > 
> > Peter has a pending queue for .37 which includes:
> > 
> > 	[RFC][PATCH 3/7] perf, hw_breakpoint: Fix crash in hw_breakpoint creation
> > 
> > This patch should fix the issue (it depends on others in the queue).
> > 
> > What is mmotm1014 BTW? Because you should see this bug only in a tree
> > that has tip:/perf/core merged inside, like linux-next.
> 
> mmotm is (usually) linux-next + akpm fixes. if a change of tip is exported
> to linux-next, it is visible from mmotm tester :)


Ok, thanks for the info :)

