Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab0CVLXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:23:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab0CVLXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:23:07 -0400
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20100322111411.GC3483@elte.hu>
Date: Mon, 22 Mar 2010 12:23:01 +0100
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
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
Content-Transfer-Encoding: 8BIT
Message-Id: <BE2E2461-D6FB-4EFB-9B95-8404563C1E1D@suse.de>
References: <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA47AD0.2010509@redhat.com> <20100321190656.GC25922@elte.hu> <4BA68009.5010906@redhat.com> <20100321205531.GC30194@elte.hu> <4BA692C3.7010408@redhat.com> <20100321215455.GB13219@elte.hu> <4BA7187E.3050405@redhat.com> <20100322111411.GC3483@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 22.03.2010, at 12:14, Ingo Molnar wrote:

> 
> * Avi Kivity <avi@redhat.com> wrote:
> 
>> On 03/21/2010 11:54 PM, Ingo Molnar wrote:
>>> * Avi Kivity<avi@redhat.com>  wrote:
>>> 
>>>> On 03/21/2010 10:55 PM, Ingo Molnar wrote:
>>>>> Of course you could say the following:
>>>>> 
>>>>>  ' Thanks, I'll mark this for v2.6.36 integration. Note that we are not
>>>>>    able to add this to the v2.6.35 kernel queue anymore as the ongoing
>>>>>    usability work already takes up all of the project's maintainer and
>>>>>    testing bandwidth. If you want the feature to be merged sooner than that
>>>>>    then please help us cut down on the TODO and BUGS list that can be found
>>>>>    at XYZ. There's quite a few low hanging fruits there. '
>>>> That would be shooting at my own foot as well as the contributor's since I
>>>> badly want that RCU stuff, and while a GUI would be nice, that itch isn't on
>>>> my back.
>>> I think this sums up the root cause of all the problems i see with KVM pretty
>>> well.
>> 
>> I think we agree at last.  Neither I nor my employer are interested in 
>> running qemu as a desktop-on-desktop tool, therefore I don't invest any 
>> effort in that direction, or require it from volunteers.
> 
> Obviously your employer at least in part defers to you when it comes to KVM 
> priorities.
> 
> So, just to make this really clear, _you_ are not interested in running qemu 
> as a desktop-on-desktop tool, subsequently this kind of 
> disinterest-for-desktop-usability trickled through the whole KVM stack and 
> poisoned your attitude and your contributor's attitude.
> 
> Too sad really and it's doubly sad that you dont feel anything wrong about 
> that.

Please, don't jump to unjust conclusions.

The whole point is that there's no money behind desktop-on-desktop virtualization. Thus nobody pays people to work on it. Thus nothing significant happens in that space.

If there was someone standing up to create a really decent desktop qemu front-end I'm confident we'd even officially suggest using that. In fact, that whole discussion did come up in the weekly Qemu/KVM community call and everybody agreed heavily that we do need a desktop client.

The problem is just that there is nobody standing up. And I hope you don't expect Avi to be the one creating a GUI.


Alex

