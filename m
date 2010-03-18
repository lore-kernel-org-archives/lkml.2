Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab0CRO1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:27:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47665 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab0CRO1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:27:13 -0400
Date: Thu, 18 Mar 2010 15:25:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John Kacur <jkacur@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Avi Kivity <avi@redhat.com>,
       Alexander Graf <agraf@suse.de>, Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100318142504.GA18269@elte.hu>
References: <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318085607.GB2157@elte.hu>
 <F0F75B33-C0BA-42EB-BFC4-D60B1E232E6D@suse.de>
 <20100318101025.GA13073@elte.hu>
 <4BA1FEB0.7000400@redhat.com>
 <20100318113527.GA13168@elte.hu>
 <y0m4okdzu4z.fsf@fche.csb>
 <520f0cf11003180601k3a08d77ej24b98f833c8d1a9a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520f0cf11003180601k3a08d77ej24b98f833c8d1a9a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Kacur <jkacur@redhat.com> wrote:

> On Thu, Mar 18, 2010 at 1:33 PM, Frank Ch. Eigler <fche@redhat.com> wrote:
> > Ingo Molnar <mingo@elte.hu> writes:
> >
> >> [...]
> >> Distributions are very eager to update kernels even in stable periods of the
> >> distro lifetime - they are much less willing to update user-space packages.
> >> [...]
> >
> > Sorry, er, what? ?What distributions eagerly upgrade kernels in stable
> > periods, were it not primarily motivated by security fixes? ?What users
> > eagerly replace their kernels?
> >
> 
> Us guys reading and participating on the list. ;)

I'd like to second that - i'm actually quite happy to update the distro 
kernel. Also, i have rarely any problems even with bleeding edge kernels in 
rawhide - they are working pretty smoothly.

A large xorg update showing up in yum update gives me the cringe though ;-)

	Ingo
