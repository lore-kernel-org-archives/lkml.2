Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab0CSJwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 05:52:12 -0400
Received: from alt.dspnet.fr.eu.org ([213.186.44.138]:4890 "EHLO
	dspnet.fr.eu.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751110Ab0CSJwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 05:52:10 -0400
Date: Fri, 19 Mar 2010 10:52:08 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
Message-ID: <20100319095207.GA31068@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Paul Mundt <lethal@linux-sh.org>,
	Anthony Liguori <anthony@codemonkey.ws>,
	Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
	oerg Roedel <joro@8bytes.org>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
	ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
	Fr?d?ric Weisbecker <fweisbec@gmail.com>
References: <4BA1FC80.2000401@redhat.com> <20100318105013.GB24464@elte.hu> <4BA20EB8.60707@redhat.com> <20100318114821.GB13168@elte.hu> <4BA21B09.6060706@redhat.com> <20100318130047.GA7424@elte.hu> <4BA23FE1.5050402@codemonkey.ws> <20100318151737.GA2875@elte.hu> <4BA250BF.80704@codemonkey.ws> <20100319091904.GF10003@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319091904.GF10003@linux-sh.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 06:19:04PM +0900, Paul Mundt wrote:
> Implementing a virtualized DRM/KMS driver would at least get you the
> framebuffer interface more or less for free, while allowing you to deal
> with the userspace side of things incrementally (ie, running a dummy xorg
> on top of the virtualized fbdev until the DRI side catches up). It would
> also enable you to focus on the 2D and 3D parts independently.

Guys, have a look at Gallium.  In many ways it's a pile of crap, but
at least it's a pile of crap designed by vmware for *exactly* your
problem space.

  OG.
