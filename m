Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab0CUXul (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 19:50:41 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45195 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab0CUXug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 19:50:36 -0400
Message-ID: <4BA6B0C7.8040001@codemonkey.ws>
Date: Sun, 21 Mar 2010 18:50:31 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
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
References: <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA47AD0.2010509@redhat.com> <20100321190656.GC25922@elte.hu> <4BA68009.5010906@redhat.com> <20100321205531.GC30194@elte.hu> <4BA692C3.7010408@redhat.com> <20100321220052.GC13219@elte.hu>
In-Reply-To: <20100321220052.GC13219@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 05:00 PM, Ingo Molnar wrote:
> If that is the theory then it has failed to trickle through in practice. As
> you know i have reported a long list of usability problems with hardly a look.
> That list could be created by pretty much anyone spending a few minutes of
> getting a first impression with qemu-kvm.
>    

I think the point you're missing is that your list was from the 
perspective of someone looking at a desktop virtualization solution that 
had was graphically oriented.

As Avi has repeatedly mentioned, so far, that has not been the target 
audience of QEMU.  The target audience tends to be: 1) people looking to 
do server virtualization and 2) people looking to do command line based 
development.

Usually, both (1) and (2) are working on machines that are remotely 
located.  What's important to these users is that VMs be easily 
launchable from the command line, that there is a lot of flexibility in 
defining machine types, and that there is a programmatic way to interact 
with a given instance of QEMU.  Those are the things that we've been 
focusing on recently.

The reason we don't have better desktop virtualization support is 
simple.  No one is volunteering to do it and no company is funding 
development for it.

When you look at something like VirtualBox, what you're looking at is a 
long ago forked version of QEMU with a GUI added focusing on desktop 
virtualization.

There is no magic behind adding a better, more usable GUI to QEMU.  It 
just takes resources.

I understand that you're trying to make the point that without catering 
to the desktop virtualization use case, we won't get as many developers 
as we could.  Personally, I don't think that argument is accurate.  If 
you look at VirtualBox, it's performance is terrible.  Having a nice GUI 
hasn't gotten them the type of developers that can improve their 
performance.

No one is arguing that we wouldn't like to have a nicer UI.  I'd love to 
merge any patch like that.

Regards,

Anthony Liguori

