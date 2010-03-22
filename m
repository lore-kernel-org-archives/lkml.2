Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab0CVRwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:52:33 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:46341 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab0CVRwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:52:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jJI2sC1V99mGPoQ+TBwMtto/w2CVXLARNNXb2qg5xdeZR3/hNLhrLZTM3Y5HdTOHUq
         LHo7Qlv2ievLHqXD59Jr7y9mQmY65Aw6+OfHLC5P12Gu2BoEcgilLO2TERtNrAXHbSde
         F1IxtbDErxM6yzF/WXd4GzN5fBqUHPAiOW0f8=
MIME-Version: 1.0
In-Reply-To: <4BA7A9AF.3010806@redhat.com>
References: <20100318172805.GB26067@elte.hu> <4BA67B2F.4030101@redhat.com>
	 <20100321203121.GA30194@elte.hu> <20100322111040.GL13108@8bytes.org>
	 <20100322122228.GH3483@elte.hu> <20100322134633.GD1940@8bytes.org>
	 <20100322163215.GC18796@elte.hu> <y0mmxy0wa1r.fsf@fche.csb>
	 <84144f021003221027t1a3e7d6ft64612654c5e50da@mail.gmail.com>
	 <4BA7A9AF.3010806@redhat.com>
Date: Mon, 22 Mar 2010 19:52:29 +0200
X-Google-Sender-Auth: dc4e6f534dd99750
Message-ID: <84144f021003221052lb693f15ped0b432c34cdd8dc@mail.gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single 
	project
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Avi Kivity <avi@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Joerg Roedel <joro@8bytes.org>, Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Fr?d?ric Weisbecker" <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

On Mon, Mar 22, 2010 at 7:32 PM, Avi Kivity <avi@redhat.com> wrote:
>> It's kinda funny to see people argue that having an external
>> repository is not a problem and that it's not a big deal if building
>> something from the repository is slightly painful as long as it
>> doesn't require a PhD when we have _real world_ experience that it
>> _does_ limit developer base in some cases. Whether or not that applies
>> to kvm remains to be seen but I've yet to see a convincing argument
>> why it doesn't.
>
> qemu has non-Linux developers.  Not all of their contributions are relevant
> to kvm but some are.  If we pull qemu into tools/kvm, we lose them.

Yeah, you probably would but the hypothesis is that you'd end up with
a bigger net developer base for the _Linux_ version. Now you might not
think that's important but I certainly do and I think Ingo does as
well. ;-)

That said, pulling 400 KLOC of code into the kernel sounds really
excessive. Would we need all that if we just do native virtualization
and no actual emulation?

                       Pekka
