Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab1JNSjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:39:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47033 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab1JNSjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:39:14 -0400
Message-ID: <4E9881A6.9050106@zytor.com>
Date: Fri, 14 Oct 2011 11:38:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        konrad.wilk@oracle.com, rth@redhat.com
Subject: Re: [PATCH RFC V5 00/11] Paravirtualized ticketlocks
References: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com> <1318503245.24856.12.camel@twins> <4E971580.6030300@goop.org> <20111014141701.GA2433@redhat.com> <4E986B2B.60803@goop.org> <20111014183539.GE2433@redhat.com>
In-Reply-To: <20111014183539.GE2433@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 11:35 AM, Jason Baron wrote:
> 
> A nice featuer of jump labels, is that it allows the various branches
> (currently we only support 2), to be written in c code (as opposed to asm),
> which means you can write your code as you normally would and access any
> parameters as you normally would - hopefully, making the code pretty
> readable as well.
> 
> I hope this better clarifies the use-cases for the various mechanisms.
> 

There is an important subcase which might be handy which would be to
allow direct patching of call instructions instead of using indirect calls.

	-hpa

