Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0CVNBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:01:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504Ab0CVNB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:01:29 -0400
Date: Mon, 22 Mar 2010 12:54:52 +0000
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Olivier Galibert <galibert@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
Message-ID: <20100322125452.GI21874@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321200849.GA51323@dspnet.fr.eu.org> <4BA67D75.8060809@redhat.com> <20100321203704.GB30194@elte.hu> <4BA71012.7070004@redhat.com> <20100322113931.GE3483@elte.hu> <4BA76649.5080307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA76649.5080307@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 02:44:57PM +0200, Avi Kivity wrote:
> On 03/22/2010 01:39 PM, Ingo Molnar wrote:
> >Reality is, the server space never was and never will be self-sustaining in
> >the long run (as Novell has found it out with Netware), it is the desktop 
> >that
> >dictates future markets. This is why i find your views about this naive and
> >shortsighted.
> >   
> 
> Yet Linux is gaining ground in the server and embedded space while 
> struggling on the desktop.  Apple is gaining ground on the desktop but 
> is invisible on the server side (despite having a nice product - Xserve).
> 
> It's true Windows achieved server dominance through it's desktop power, 
> but I don't think that's what keeping them there now.
> 
> In any case, I'm not going to write a kvm GUI.  It doesn't match my 
> skills, interest, or my employer's interest.  If you wish to see a kvm 
> GUI you have to write one yourself or convince someone to write it 
> (perhaps convince Red Hat to fund such an effort beyond virt-manager).

It is planned to add support for SPICE remote desktop to virt-manager
once that matures & is accepted into upstream KVM/QEMU. That will improve
the guest/desktop interaction in many ways compared to VNC or SDL, with
improved display resolution changing, copy+paste between host & guest,
much better graphics performance, etc. 

Development efforts aren't totally ignoring the desktop, more that they
are focusing on remoting guest desktops, rather than interaction host 
desktop since that's where alot of demand is. This benefits single host
desktops scenarios too, since there's alot of overlap in the problems
faced there.

Regards,
Daniel
-- 
|: Red Hat, Engineering, London    -o-   http://people.redhat.com/berrange/ :|
|: http://libvirt.org -o- http://virt-manager.org -o- http://deltacloud.org :|
|: http://autobuild.org        -o-         http://search.cpan.org/~danberr/ :|
|: GnuPG: 7D3B9505  -o-   F3C9 553F A1DA 4AC2 5648 23C1 B3DF F742 7D3B 9505 :|
