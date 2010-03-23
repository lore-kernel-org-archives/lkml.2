Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab0CWJqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 05:46:13 -0400
Received: from alt.dspnet.fr.eu.org ([213.186.44.138]:2600 "EHLO
	dspnet.fr.eu.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751583Ab0CWJqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 05:46:11 -0400
Date: Tue, 23 Mar 2010 10:46:08 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Avi Kivity <avi@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>, sandmann@daimi.au.dk
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
Message-ID: <20100323094608.GA33152@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
	Avi Kivity <avi@redhat.com>,
	Anthony Liguori <anthony@codemonkey.ws>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
	oerg Roedel <joro@8bytes.org>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
	ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
	Fr?d?ric Weisbecker <fweisbec@gmail.com>, sandmann@daimi.au.dk
References: <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321203121.GA30194@elte.hu> <4BA6900B.1040408@redhat.com> <20100321215207.GA13219@elte.hu> <4BA712F0.5030806@redhat.com> <20100322112340.GD3483@elte.hu> <4BA76746.1000505@redhat.com> <84144f021003220601q1b4b9050x5eb87dfaf10c3c85@mail.gmail.com> <20100322145437.GG14201@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322145437.GG14201@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 03:54:37PM +0100, Ingo Molnar wrote:
> Yes, i thought Qemu would be a prime candidate to be the baseline for 
> tools/kvm/, but i guess that has become socially impossible now after this 
> flamewar. It's not a big problem in the big scheme of things: tools/kvm/ is 
> best grown up from a small towards larger size anyway ...

I'm curious, where would you put the limit?  Let's imagine a tools/kvm
appears, be it qemu or not, that's outside the scope of my question.
Would you put the legacy PC bios in there (seabios I guess)?  The EFI
bios? The windows-compiled paravirtual drivers? The Xorg paravirtual
DDX ?  Mesa (which includes the pv gallium drivers)? The
libvirt-equivalent? The GUI?

That's not a rhetorical question btw, I really wonder where the limit
should be.

  OG.
