Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220Ab0CPQJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:09:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758278Ab0CPQJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:09:08 -0400
Date: Tue, 16 Mar 2010 12:08:22 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from host side
Message-ID: <20100316160822.GE9841@redhat.com>
References: <4B9F671D.5060001@redhat.com> <20100316112500.GA5337@elte.hu> <4B9F77E7.2060101@redhat.com> <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu> <4B9F84C0.70706@redhat.com> <20100316133114.GB575@elte.hu> <y0mbpeo1f1y.fsf@fche.csb> <20100316155221.GA19699@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316155221.GA19699@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Mar 16, 2010 at 04:52:21PM +0100, Ingo Molnar wrote:
> [...]
> > Perhaps the fact that kvm happens to deal with an interesting application 
> > area (virtualization) is misleading here.  As far as the host kernel or 
> > other host userspace is concerned, qemu is just some random unprivileged 
> > userspace program [...]

> You are quite mistaken: KVM isnt really a 'random unprivileged
> application' in this context, it is clearly an extension of
> system/kernel services.

I don't know what "extension of system/kernel services" means in this
context, beyond something running on the system/kernel, like every
other process.  To clarify, to what extent do you consider your
classification similarly clear for a host is running

* multiple kvm instances run as unprivileged users
* non-kvm OS simulators such as vmware or xen or gdb
* kvm instances running something other than linux

> ( Which can be seen from the simple fact that what started the
> discussion was 'how do we get /proc/kallsyms from the
> guest'. I.e. an extension of the existing host-space /proc/kallsyms
> was desired. )

(Sorry, that smacks of circular reasoning.)

It may be a charming convenience function for perf users to give them
shortcuts for certain favoured configurations (kvm running freshest
linux), but that says more about perf than kvm.


- FChE
