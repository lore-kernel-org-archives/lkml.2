Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab1JNTKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:10:36 -0400
Received: from claw.goop.org ([74.207.240.146]:53011 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785Ab1JNTKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:10:35 -0400
Message-ID: <4E988929.8040801@goop.org>
Date: Fri, 14 Oct 2011 12:10:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        konrad.wilk@oracle.com
Subject: Re: [PATCH RFC V5 00/11] Paravirtualized ticketlocks
References: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com> <1318503245.24856.12.camel@twins> <4E971580.6030300@goop.org> <20111014141701.GA2433@redhat.com> <4E986B2B.60803@goop.org> <4E98815F.6080105@zytor.com>
In-Reply-To: <4E98815F.6080105@zytor.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 11:37 AM, H. Peter Anvin wrote:
> On 10/14/2011 10:02 AM, Jeremy Fitzhardinge wrote:
>> Jump labels are essentially binary: you can use path A or path B.  pvops
>> are multiway: there's no limit to the number of potential number of
>> paravirtualized hypervisor implementations.  At the moment we have 4:
>> native, Xen, KVM and lguest.
>>
> This isn't (or shouldn't be) really true... it should be possible to do
> an N-way jump label even if the current mechanism doesn't.

We probably don't want all those implementations (near) inline, so they
would end up being plain function calls anyway.

    J
