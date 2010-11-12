Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab0KLLKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:10:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:56238 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab0KLLKa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:10:30 -0500
Subject: Re: [tg_shares_up rewrite v3 01/11] sched: rewrite tg_shares_up
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
In-Reply-To: <20101112032701.393756125@google.com>
References: <20101112032405.657789056@google.com>
	 <20101112032701.393756125@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 12 Nov 2010 12:10:01 +0100
Message-ID: <1289560201.2084.215.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 19:24 -0800, Paul Turner wrote:
> --- include/linux/sched.h.orig
> +++ include/linux/sched.h 

You generated -p0 patches.. that caused utter destruction with my apply
scripts.

Could you please repost as -p1 patches?
