Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab0CSO1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 10:27:49 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:35935 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab0CSO1r (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 19 Mar 2010 10:27:47 -0400
Date: Fri, 19 Mar 2010 09:56:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Olivier Galibert <galibert@pobox.com>, Paul Mundt <lethal@linux-sh.org>,
       Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [LKML] Re: [RFC] Unify KVM kernel-space and user-space code
	into a single project
Message-ID: <20100319135606.GA24262@phenom.dumpdata.com>
References: <20100318105013.GB24464@elte.hu> <4BA20EB8.60707@redhat.com> <20100318114821.GB13168@elte.hu> <4BA21B09.6060706@redhat.com> <20100318130047.GA7424@elte.hu> <4BA23FE1.5050402@codemonkey.ws> <20100318151737.GA2875@elte.hu> <4BA250BF.80704@codemonkey.ws> <20100319091904.GF10003@linux-sh.org> <20100319095207.GA31068@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319095207.GA31068@dspnet.fr.eu.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BA3893B.0069:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 10:52:08AM +0100, Olivier Galibert wrote:
> On Fri, Mar 19, 2010 at 06:19:04PM +0900, Paul Mundt wrote:
> > Implementing a virtualized DRM/KMS driver would at least get you the
> > framebuffer interface more or less for free, while allowing you to deal
> > with the userspace side of things incrementally (ie, running a dummy xorg
> > on top of the virtualized fbdev until the DRI side catches up). It would
> > also enable you to focus on the 2D and 3D parts independently.
> 
> Guys, have a look at Gallium.  In many ways it's a pile of crap, but
> at least it's a pile of crap designed by vmware for *exactly* your
> problem space.

Or perhaps Chromium, which was designed years ago and can pass-through
OpenGL commands via a pipe. VirtualBox uses it for their PV drivers.
Naturally it is not a FB, just a OpenGL command pass-through interface.
