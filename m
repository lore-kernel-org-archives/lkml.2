Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab1JNTN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:13:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47685 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361Ab1JNTN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:13:26 -0400
Message-ID: <4E9889AF.1050106@zytor.com>
Date: Fri, 14 Oct 2011 12:12:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
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
References: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com> <1318503245.24856.12.camel@twins> <4E971580.6030300@goop.org> <20111014141701.GA2433@redhat.com> <4E986B2B.60803@goop.org> <4E98815F.6080105@zytor.com> <4E988929.8040801@goop.org>
In-Reply-To: <4E988929.8040801@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 12:10 PM, Jeremy Fitzhardinge wrote:
> 
> We probably don't want all those implementations (near) inline, so they
> would end up being plain function calls anyway.
> 

I would not object if the native one was closer, though; especially in
term of source text (the current level of macroization of some
operations is horrific.)

	-hpa


