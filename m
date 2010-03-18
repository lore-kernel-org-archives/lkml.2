Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0CRRMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:12:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39342 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab0CRRMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:12:33 -0400
Date: Thu, 18 Mar 2010 18:11:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100318171132.GC9756@elte.hu>
References: <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318085607.GB2157@elte.hu>
 <4BA1FC80.2000401@redhat.com>
 <20100318105013.GB24464@elte.hu>
 <4BA20EB8.60707@redhat.com>
 <20100318114821.GB13168@elte.hu>
 <4BA23E61.4080003@codemonkey.ws>
 <20100318161310.GA447@elte.hu>
 <4BA25ADC.7040504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA25ADC.7040504@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

> On 03/18/2010 06:13 PM, Ingo Molnar wrote:
>
> > Currently there's a wall between kernel developers and user-space 
> > developers, and there's somewhat of an element of fear and arrogance on 
> > both sides. For efficient technology such walls needs torn down and people 
> > need a bit more experience with each other's areas.
> 
> I think you're increasing the height of that wall by arguing that a 
> userspace project cannot be successful because it's development process 
> sucks and the only way to fix it is to put it into the kernel where people 
> know so much better.  Instead we kernel developers should listen to 
> requirements from users, even if their code isn't in tools/.

No, it's tearing down that wall because finally, instead of providing rather 
abstract system calls that are designed perfectly, the kernel can operate by 
providing useful libraries and apps.

At least on the context i've worked on it has torn down walls and has improved 
the efficiency of working on ABIs towards user-space. (sysprof is an example 
of that)

Kernel developers are finally faced with user-space development directly, in 
the same repository, using the same rules of contribution.

Non-kernel-hosted apps win from that process too, as even if they dont 
integrate (because they dont want to or cannot for license reasons) they can 
participate in a more direct (and more practical) exchange with kernel 
developers. They can contribute a new system call and create a library 
function for it straight away.

	Ingo
