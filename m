Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab0CVT6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:58:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:37813 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755966Ab0CVT6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:58:32 -0400
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20100322195403.GC3306@elte.hu>
Date: Mon, 22 Mar 2010 20:58:26 +0100
Cc: "Daniel P. Berrange" <berrange@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>,
       LKML Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel General <kvm@vger.kernel.org>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <2D740A89-F53F-4F72-B44C-B72942E883E9@suse.de>
References: <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu> <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu> <4BA7AF2D.7060306@redhat.com> <4BA7C1D7.5070208@codemonkey.ws> <20100322193100.GB28709@redhat.com> <E548536E-4D62-4B17-BA09-9C12EB1A2717@suse.de> <20100322195403.GC3306@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 22.03.2010, at 20:54, Ingo Molnar wrote:

> 
> * Alexander Graf <agraf@suse.de> wrote:
> 
>> Yes. I think the point was that every layer in between brings potential 
>> slowdown and loss of features.
> 
> Exactly. The more 'fragmented' a project is into sub-projects, without a 
> single, unified, functional reference implementation in the center of it, the 
> longer it takes to fix 'unsexy' problems like trivial usability bugs.

I agree to that part. As previously stated there are few people working on qemu that would go and implement higher level things though. So some solution is needed there.

> Furthermore, another negative effect is that many times features are 
> implemented not in their technically best way, but in a way to keep them local 
> to the project that originates them. This is done to keep deployment latencies 
> and general contribution overhead down to a minimum. The moment you have to 
> work with yet another project, the overhead adds up.

I disagree there. Keeping things local and self-contained has been the UNIX secret. It works really well as long as the boundaries are well defined.

The problem we're facing is that we're simply lacking an active GUI / desktop user development community. We have desktop users, but nobody feels like tackling the issue of doing a great GUI project while talking to qemu-devel about his needs.

> So developers rather go for the quicker (yet inferior) hack within the 
> sub-project they have best access to.

Well - not necessarily hacks. It's more about project boundaries. Nothing is bad about that. You wouldn't want "ls" implemented in the Linux kernel either, right? :-)


Alex