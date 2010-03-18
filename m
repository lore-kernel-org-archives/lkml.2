Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab0CRTQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 15:16:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52328 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab0CRTQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 15:16:06 -0400
Date: Thu, 18 Mar 2010 20:15:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: drepper@gmail.com
Cc: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100318191555.GA9741@elte.hu>
References: <20100318161310.GA447@elte.hu>
 <g6xw3whylji5t7k79aUYAxe124vaj_firegpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g6xw3whylji5t7k79aUYAxe124vaj_firegpg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* drepper@gmail.com <drepper@gmail.com> wrote:

> On Thu, Mar 18, 2010 at 09:13, Ingo Molnar <mingo@elte.hu> wrote:
>
> > The suckage of kernel async IO is for similar reasons: there's an ugly 
> > package separation problem between the kernel and between glibc
> 
> Bollocks.  glibc would use (and is using) everything the kernel provides.

I didnt say it's glibc's fault - if then it's more of the kernel's fault as 
most of the complexity is on that side. I said it's due to the fundamental 
distance between the app that makes use of it, the library and the kernel, and 
the resulting difficulties in getting a combined solution out.

None of the parties really feels it to be their own thing.

	Ingo
