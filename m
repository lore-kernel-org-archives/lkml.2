Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0CRNpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:45:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab0CRNpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:45:21 -0400
Date: Thu, 18 Mar 2010 13:44:57 +0000
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
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
Message-ID: <20100318134457.GH22775@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu> <F0F75B33-C0BA-42EB-BFC4-D60B1E232E6D@suse.de> <20100318101025.GA13073@elte.hu> <4BA1FEB0.7000400@redhat.com> <20100318113527.GA13168@elte.hu> <y0m4okdzu4z.fsf@fche.csb> <20100318130226.GB7424@elte.hu> <4BA22663.7070509@redhat.com> <20100318133124.GA25642@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318133124.GA25642@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 02:31:24PM +0100, Ingo Molnar wrote:
> 
> * Avi Kivity <avi@redhat.com> wrote:
> 
> > On 03/18/2010 03:02 PM, Ingo Molnar wrote:
> > >
> > >> [...] What users eagerly replace their kernels?
> > >
> > > Those 99% who click on the 'install 193 updates' popup.
> > >
> > 
> > Of which 1 is the kernel, and 192 are userspace updates (of which one may be 
> > qemu).
> 
> I think you didnt understand my (tersely explained) point - which is probably 
> my fault. What i said is:
> 
>  - distros update the kernel first. Often in stable releases as well if 
>    there's a new kernel released. (They must because it provides new hardware
>    enablement and other critical changes they generally cannot skip.)
> 
>  - Qemu on the other hand is not upgraded with (nearly) that level of urgency.
>    Completely new versions will generally have to wait for the next distro
>    release.

This has nothing todo with them being in separate source repos. We could
update QEMU to new major feature releaes with the same frequency in a Fedora
release, but we delibrately choose not to rebase the QEMU userspace because 
experiance has shown the downside from new bugs / regressions outweighs the
benefit of any new features.

The QEMU updates in stable Fedora trees, now just follow the minor bugfix
release stream provided by QEMU & those arrive in Fedora with little
noticable delay.

Daniel
-- 
|: Red Hat, Engineering, London    -o-   http://people.redhat.com/berrange/ :|
|: http://libvirt.org -o- http://virt-manager.org -o- http://deltacloud.org :|
|: http://autobuild.org        -o-         http://search.cpan.org/~danberr/ :|
|: GnuPG: 7D3B9505  -o-   F3C9 553F A1DA 4AC2 5648 23C1 B3DF F742 7D3B 9505 :|
