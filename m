Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab1KDKlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 06:41:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065Ab1KDKlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 06:41:44 -0400
Message-ID: <4EB3C167.3020508@suse.cz>
Date: Fri, 04 Nov 2011 11:41:43 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Richard Weinberger <richard@nod.at>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Foley <pefoley2@verizon.net>
Subject: Re: [GIT PULL] UML changes for 3.2
References: <4EB14F51.1050004@nod.at>	 <1320348750.14409.249.camel@x61.thuisdomein>	 <1320352899.14409.260.camel@x61.thuisdomein>	 <1320354072.14409.265.camel@x61.thuisdomein>  <4EB3045A.6050501@nod.at>	 <1320355503.14409.269.camel@x61.thuisdomein>  <4EB30994.9050309@nod.at>	 <1320357369.14409.276.camel@x61.thuisdomein> <1320358228.14409.279.camel@x61.thuisdomein>
In-Reply-To: <1320358228.14409.279.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.11.2011 23:10, Paul Bolle wrote:
> On Thu, 2011-11-03 at 22:56 +0100, Paul Bolle wrote:
>> These Makefiles always make me nervous. Is SUBARCH set by the time the
>> update-po-config target is run? If so, we could simply do "env SUBARCH=
>> $(SUBARCH) [...]". But how do I check that SUBARCH really is set (ie,
>> that I'm not passing env an empty string)?
> 
> It seems the trick here should be
>     env SUBARCH=$(KBUILD_BUILDHOST) [...]
> 
> Michal, does that make sense?

I doub't kxgettext needs $SUBARCH at all, it only cares about the
prompts and help texts, it does not evaluate any kconfig symbols.

Michal
