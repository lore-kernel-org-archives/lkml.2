Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab0CVMuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:50:54 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:46819 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab0CVMux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:50:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OiutCUIQgRUU8ztQPMC0kp4ZwTMkEMX1nHIMbBbloOwqU7HOCzg3JcBfpqx70t0BWx
         hOYH/u22X4ULiH8Rlv1D6rqNQmblzeA/bzYzpKTP17YAY/oPjL2/ZaBjq8y7YCzjzzbH
         +LfEIggwTDwHIsHut2RZs0ZNzJM0N3Zci8V5I=
MIME-Version: 1.0
In-Reply-To: <4BA76443.7030104@redhat.com>
References: <20100321191742.GD25922@elte.hu> <4BA67D75.8060809@redhat.com>
	 <4BA67F12.6030501@nagafix.co.uk> <4BA68063.2050800@redhat.com>
	 <4BA68234.1060804@nagafix.co.uk> <4BA68997.60406@redhat.com>
	 <20100321212009.GE30194@elte.hu> <4BA70F9A.8030304@redhat.com>
	 <20100322114824.GF3483@elte.hu> <4BA76443.7030104@redhat.com>
Date: Mon, 22 Mar 2010 14:50:50 +0200
X-Google-Sender-Auth: ca5c85e5376240d7
Message-ID: <84144f021003220550g6420b659kefaf2a31dc9144b7@mail.gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single 
	project
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Antoine Martin <antoine@nagafix.co.uk>,
       Olivier Galibert <galibert@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Fr?d?ric Weisbecker" <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 2:36 PM, Avi Kivity <avi@redhat.com> wrote:
>> Here it is, repeated for the Nth time:
>>
>> Allow a guest to (optionally) integrate its VFS namespace with the host
>> side
>> as well. An example scheme would be:
>>
>>    /guests/Fedora-G1/
>>
>
> [...]
>
> You're missing something.  This sub-thread is about someone launching a
> kernel with 'qemu -kernel', the kernel lives outside the guest disk image,
> they don't want a custom initrd because it's hard to make.

Well, you know, I am missing your point here about initrd. Surely the
guest kernels need to use sys_mount() at some point at which time they
could just tell the host kernel where they can find the mount points?
But maybe we're not talking about that kind of scenario here?

                        Pekka
