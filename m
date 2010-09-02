Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab0IBGyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 02:54:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38963 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab0IBGyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 02:54:08 -0400
Date: Thu, 2 Sep 2010 08:53:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Chris Mason <chris.mason@oracle.com>, Yan Zheng <zheng.yan@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH V2 0/3] improve the performance of some memory copy
 functions
Message-ID: <20100902065347.GA29972@elte.hu>
References: <4C7F3A26.6020607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7F3A26.6020607@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miao Xie <miaox@cn.fujitsu.com> wrote:

> - change the version of GPL from version 2.1 to version 2

How were you able to do this? If the code derives from glibc (as your 
comments in the patches suggest), and if glibc is under the GPL v2.1, 
then you probably cannot simply change the license to v2.

	Ingo
