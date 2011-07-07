Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1GGQYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 12:24:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab1GGQYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 12:24:16 -0400
Date: Thu, 7 Jul 2011 12:23:44 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@openvz.org>, Hu Tao <hutao@cn.fujitsu.com>
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
Message-ID: <20110707162344.GB2536@redhat.com>
References: <20110707053036.173186930@google.com>
 <20110707112302.GB8227@elte.hu>
 <1310049528.3282.583.camel@twins>
 <20110707145159.GD19193@elte.hu>
 <1310050482.3282.584.camel@twins>
 <20110707145620.GF19193@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707145620.GF19193@elte.hu>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 04:56:20PM +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Thu, 2011-07-07 at 16:51 +0200, Ingo Molnar wrote:
> > > > Going beyond that
> > > > would be using static_branch() to track if there is any bandwidth
> > > > tracking required at all.
> > > 
> > > Could jump labels be utilized perhaps? 
> > 
> > # git grep static_branch include/linux/
> > include/linux/jump_label.h:static __always_inline bool static_branch(struct jump_label_key *key)
> 
> Right - i only read up to your first, __always_inline suggestion :)
> 
> Thanks,
> 
> 	Ingo

yes, this is the type of case jump labels is designed for. Let me know
if there are any usage questions/concerns.

thanks,

-Jason
