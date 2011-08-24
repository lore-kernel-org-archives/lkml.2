Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab1HXWGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:06:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48319 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab1HXWGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:06:38 -0400
Message-ID: <4E5575AC.5060707@zytor.com>
Date: Wed, 24 Aug 2011 15:05:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 07/12] x86: use cmpxchg_flag() where applicable
References: <e1c8d3bcee83cc5ad00bdf8900a99add7abb1cb9.1314221624.git.jeremy.fitzhardinge@citrix.com> <cover.1314207974.git.jeremy.fitzhardinge@citrix.com> <3d7aea62fac48dd6e2da236d86234113fcd78178.1314221624.git.jeremy.fitzhardinge@citrix.com> <CA+55aFwEH16JAynxQzNTff0ikGnON9jq1mJOx1doDASV2a2fpg@mail.gmail.com> <4E5574C3.6080104@zytor.com> <4E557534.3030408@goop.org>
In-Reply-To: <4E557534.3030408@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 03:03 PM, Jeremy Fitzhardinge wrote:
> 
> Well, we could keep the API (since it is convenient), but just implement
> it with a compare.
> 

It seems like a gratuitous change at this point to me, but I don't have
a strong opinion one way or the other.

	-hpa

