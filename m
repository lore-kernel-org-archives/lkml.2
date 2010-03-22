Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab0CVMq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:46:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab0CVMqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:46:55 -0400
Message-ID: <4BA76649.5080307@redhat.com>
Date: Mon, 22 Mar 2010 14:44:57 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Olivier Galibert <galibert@pobox.com>,
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
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321200849.GA51323@dspnet.fr.eu.org> <4BA67D75.8060809@redhat.com> <20100321203704.GB30194@elte.hu> <4BA71012.7070004@redhat.com> <20100322113931.GE3483@elte.hu>
In-Reply-To: <20100322113931.GE3483@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 01:39 PM, Ingo Molnar wrote:
> Reality is, the server space never was and never will be self-sustaining in
> the long run (as Novell has found it out with Netware), it is the desktop that
> dictates future markets. This is why i find your views about this naive and
> shortsighted.
>    

Yet Linux is gaining ground in the server and embedded space while 
struggling on the desktop.  Apple is gaining ground on the desktop but 
is invisible on the server side (despite having a nice product - Xserve).

It's true Windows achieved server dominance through it's desktop power, 
but I don't think that's what keeping them there now.

In any case, I'm not going to write a kvm GUI.  It doesn't match my 
skills, interest, or my employer's interest.  If you wish to see a kvm 
GUI you have to write one yourself or convince someone to write it 
(perhaps convince Red Hat to fund such an effort beyond virt-manager).

-- 
error compiling committee.c: too many arguments to function

