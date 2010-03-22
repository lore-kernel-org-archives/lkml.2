Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab0CVSKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:10:54 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60154 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab0CVSKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=hI+hPUYwjSqmj6x9TjePKiSHtpm9vBlMKZrZ+ZkxBZkexdK+74BAS0x3e65lbbwW3t
         DOKjuwcTxD9vU3Ez3DHEySEFilF+hN4uBEhLHecP5KWmh1M0hVmhiZn+ehMUymLoi2q4
         Hfs8PZSMm2QHPkBlu0ygxvslYn47krVdmXiTY=
MIME-Version: 1.0
In-Reply-To: <4BA7B119.1070800@redhat.com>
References: <20100318172805.GB26067@elte.hu>
	 <20100322111040.GL13108@8bytes.org> <20100322122228.GH3483@elte.hu>
	 <20100322134633.GD1940@8bytes.org> <20100322163215.GC18796@elte.hu>
	 <y0mmxy0wa1r.fsf@fche.csb>
	 <84144f021003221027t1a3e7d6ft64612654c5e50da@mail.gmail.com>
	 <4BA7A9AF.3010806@redhat.com>
	 <84144f021003221052lb693f15ped0b432c34cdd8dc@mail.gmail.com>
	 <4BA7B119.1070800@redhat.com>
Date: Mon, 22 Mar 2010 20:10:50 +0200
X-Google-Sender-Auth: bb9963e880b3a883
Message-ID: <84144f021003221110p79db476fpae25f6997b61b0b9@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 8:04 PM, Avi Kivity <avi@redhat.com> wrote:
>> That said, pulling 400 KLOC of code into the kernel sounds really
>> excessive. Would we need all that if we just do native virtualization
>> and no actual emulation?
>
> What is native virtualization and no actual emulation?

What I meant with "actual emulation" was running architecture A code
on architecture B what was qemu's traditional use case. So the
question was how much of the 400 KLOC do we need for just KVM on all
the architectures that it supports?
