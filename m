Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab0CVTSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:18:49 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:63116 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab0CVTSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:18:46 -0400
Message-ID: <4BA7C28D.6050502@codemonkey.ws>
Date: Mon, 22 Mar 2010 14:18:37 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Joerg Roedel <joro@8bytes.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321203121.GA30194@elte.hu> <20100322111040.GL13108@8bytes.org> <20100322122228.GH3483@elte.hu> <20100322134633.GD1940@8bytes.org> <20100322163215.GC18796@elte.hu> <4BA7AC6B.3050103@redhat.com> <20100322191028.GB21919@elte.hu>
In-Reply-To: <20100322191028.GB21919@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 02:10 PM, Ingo Molnar wrote:
>
> I posit that it's both: and that priorities can be communicated - if only you
> try as a maintainer. All i'm suggesting is to add 'usable, unified user-space'
> to the list of unfun priorities, because it's possible and because it matters.
>    

I've spent the past few months dealing with customers using the 
libvirt/qemu/kvm stack.  Usability is a major problem and is a top 
priority for me.  That is definitely a shift but that occurred before 
you started your thread.

But I disagree with your analysis of what the root of the problem is.  
It's a very kernel centric view and doesn't consider the interactions 
between userspace.

Regards,

Anthony Liguori

> 	Ingo
>    

