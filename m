Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0CROmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:42:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab0CROmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:42:11 -0400
Date: Thu, 18 Mar 2010 10:39:51 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: John Kacur <jkacur@redhat.com>, Avi Kivity <avi@redhat.com>,
       Alexander Graf <agraf@suse.de>, Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
Message-ID: <20100318143951.GB23126@redhat.com>
References: <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu> <F0F75B33-C0BA-42EB-BFC4-D60B1E232E6D@suse.de> <20100318101025.GA13073@elte.hu> <4BA1FEB0.7000400@redhat.com> <20100318113527.GA13168@elte.hu> <y0m4okdzu4z.fsf@fche.csb> <520f0cf11003180601k3a08d77ej24b98f833c8d1a9a@mail.gmail.com> <20100318142504.GA18269@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318142504.GA18269@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Mar 18, 2010 at 03:25:04PM +0100, Ingo Molnar wrote:
> [...]
> > Us guys reading and participating on the list. ;)
> 
> I'd like to second that - i'm actually quite happy to update the distro 
> kernel. Also, i have rarely any problems even with bleeding edge kernels in 
> rawhide - they are working pretty smoothly.
> 
> A large xorg update showing up in yum update gives me the cringe though ;-)

>From a parochial point of view, that makes perfect sense: someone
else's large software changes are a source of concern.  The same thing
applies to non-LKML people -- ordinary users -- when *your* large
software changes are proposed.

Perhaps this change in perspective would help you see the absurdity of
proposing kernel-2.6.git as a hosting repository for all kinds of
stuff, on the theory that kernel updates get pushed to "eager" users
more frequently than other kinds of updates.  (Never mind that data
shows otherwise.)


- FChE
