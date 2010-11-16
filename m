Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934358Ab0KPMbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 07:31:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:42473 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab0KPMbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 07:31:23 -0500
Subject: Re: [tg_shares_up rewrite v4 00/11] reduce overhead for tg->shares
 distribution
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Karl Rister <kmr@us.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
In-Reply-To: <20101115234659.610333554@google.com>
References: <20101115234659.610333554@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 16 Nov 2010 13:31:23 +0100
Message-ID: <1289910683.2109.593.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 15:46 -0800, Paul Turner wrote:
> 
> This is v4 of the tg_shares_up re-write previously posted at:
> http://lkml.org/lkml/2010/10/16/17
> 
> Corrected versus the previous version is the quilt patch-strip level.
> 
> The key idea behind this patchset is an idea of Peter Zijlstra'a to compute
> global loads as a function of local averages, avoiding the cpu-cpu interactions
> which previously plagued tg_shares_up.
> 
> Beyond bug fixes not much material has changed since v1 as results seem
> favourable/stable.


Thanks, applied!
