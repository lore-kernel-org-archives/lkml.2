Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0CVMzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:55:06 -0400
Received: from core.mokelbu.de ([85.10.222.94]:34410 "EHLO core.mokelbu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768Ab0CVMzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:55:04 -0400
X-Greylist: delayed 1262 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Mar 2010 08:55:03 EDT
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
From: Lukas Kolbe <l-lists@einfachkaffee.de>
To: Alexander Graf <agraf@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <BE2E2461-D6FB-4EFB-9B95-8404563C1E1D@suse.de>
References: <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com>
	 <20100319085346.GG12576@elte.hu> <4BA47AD0.2010509@redhat.com>
	 <20100321190656.GC25922@elte.hu> <4BA68009.5010906@redhat.com>
	 <20100321205531.GC30194@elte.hu> <4BA692C3.7010408@redhat.com>
	 <20100321215455.GB13219@elte.hu> <4BA7187E.3050405@redhat.com>
	 <20100322111411.GC3483@elte.hu>
	 <BE2E2461-D6FB-4EFB-9B95-8404563C1E1D@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Mar 2010 13:33:55 +0100
Message-ID: <1269261235.3174.18.camel@larosa.zuhause>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.92.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 22.03.2010, 12:23 +0100 schrieb Alexander Graf:
 
> >> I think we agree at last.  Neither I nor my employer are interested in 
> >> running qemu as a desktop-on-desktop tool, therefore I don't invest any 
> >> effort in that direction, or require it from volunteers.
> > 
> > Obviously your employer at least in part defers to you when it comes to KVM 
> > priorities.
> > 
> > So, just to make this really clear, _you_ are not interested in running qemu 
> > as a desktop-on-desktop tool, subsequently this kind of 
> > disinterest-for-desktop-usability trickled through the whole KVM stack and 
> > poisoned your attitude and your contributor's attitude.
> > 
> > Too sad really and it's doubly sad that you dont feel anything wrong about 
> > that.
> 
> Please, don't jump to unjust conclusions.
> 
> The whole point is that there's no money behind desktop-on-desktop
> virtualization. Thus nobody pays people to work on it. Thus nothing
> significant happens in that space.
> 
> If there was someone standing up to create a really decent desktop
> qemu front-end I'm confident we'd even officially suggest using that.
> In fact, that whole discussion did come up in the weekly Qemu/KVM
> community call and everybody agreed heavily that we do need a desktop
> client.
> 
> The problem is just that there is nobody standing up. And I hope you
> don't expect Avi to be the one creating a GUI.

Besides, Ingo could just go ahead and use libvirt together with
virt-manager. It solves a few of the usability issues he came up with
somewhere in this thread, is available even in every current
distribution, and *actually* works quite well for the desktop usecase.
It just desparatly needs more brainpower and manpower to make it a
competitor to VirtualBox & Co, because its not as polished and
featurecomplete yet. But I bet virt-managers maintainers welcome patches
to fix and enhance usability. Most of the needed fixes probably wouldn't
touch qemu at all, let alone kvm.

Sorry to chime in with my opinion, but this whole thread is incredibly
boring and full of non-arguments yet really highly amusing.

-- 
Lukas


