Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1CQIJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 04:09:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52918 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab1CQIJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 04:09:56 -0400
Date: Thu, 17 Mar 2011 09:09:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] oprofile cleanups
Message-ID: <20110317080942.GA26190@elte.hu>
References: <1300298305-9164-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300298305-9164-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Robert Richter <robert.richter@amd.com> wrote:

> These 2 patches contain some cleanups I made while reviewing oprofile
> s390 code. I already applied them to my oprofile git tree, but please
> take a look at it anyway.
> 
> Ingo, since the patches are cleanups, I think it is ok to add them to
> my oprofile pull request for .39 for you that I will send out soon.
> All other patches are already in linux-next for several weeks. Is this
> ok for you too?

Yeah, assuming Mike's remarks have been addressed.

Thanks,

	Ingo
