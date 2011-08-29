Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab1H2US2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 16:18:28 -0400
Received: from mga06.intel.com ([134.134.136.21]:32124 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755078Ab1H2USZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 16:18:25 -0400
Subject: Re: linux-next: build warning after merge of the ptrace tree
From: Matt Fleming <matt.fleming@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110829182018.GA14729@redhat.com>
References: <20110829152704.e533760bfb83fc7480333b20@canb.auug.org.au>
	 <20110829182018.GA14729@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Mon, 29 Aug 2011 21:18:14 +0100
Message-ID: <1314649094.3649.1.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 20:20 +0200, Oleg Nesterov wrote:
> Hi Stephen,
> 
> On 08/29, Stephen Rothwell wrote:
> >
> > After merging the ptrace tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced this warning:
> >
> > fs/autofs4/waitq.c: In function 'autofs4_wait':
> > fs/autofs4/waitq.c:462:17: warning: unused variable 'irqflags'
> >
> > Introduced by commit 33ee1d9bc213 ("autofs4: Use set_current_blocked()").
> 
> Argh. Thanks again.
> 
> I've committed the trivial fix.

Thanks Oleg! Sorry about that, my build was pretty loud and I missed
this warning in the noise.


