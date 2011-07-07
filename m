Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab1GGO4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:56:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53119 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab1GGO4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:56:31 -0400
Date: Thu, 7 Jul 2011 16:56:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@openvz.org>, Hu Tao <hutao@cn.fujitsu.com>
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
Message-ID: <20110707145620.GF19193@elte.hu>
References: <20110707053036.173186930@google.com>
 <20110707112302.GB8227@elte.hu>
 <1310049528.3282.583.camel@twins>
 <20110707145159.GD19193@elte.hu>
 <1310050482.3282.584.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310050482.3282.584.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2011-07-07 at 16:51 +0200, Ingo Molnar wrote:
> > > Going beyond that
> > > would be using static_branch() to track if there is any bandwidth
> > > tracking required at all.
> > 
> > Could jump labels be utilized perhaps? 
> 
> # git grep static_branch include/linux/
> include/linux/jump_label.h:static __always_inline bool static_branch(struct jump_label_key *key)

Right - i only read up to your first, __always_inline suggestion :)

Thanks,

	Ingo
