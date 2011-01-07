Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1AGHvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 02:51:13 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:42900 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab1AGHvM convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Fri, 7 Jan 2011 02:51:12 -0500
Message-Id: <4D26D3FD020000780002AED9@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 07 Jan 2011 07:51:09 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "David Rientjes" <rientjes@google.com>, "Tejun Heo" <tj@kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: unify "numa=" command line option handling
References: <4D2603BF020000780002ACA7@vpn.id2.novell.com>
 <alpine.DEB.2.00.1101061235010.30820@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1101061235010.30820@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.01.11 at 21:36, David Rientjes <rientjes@google.com> wrote:
> On Thu, 6 Jan 2011, Jan Beulich wrote:
> 
>> In order to be able to suppress the use of SRAT tables that 32-bit
>> Linux can't deal with (possibly leading to a non-bootable system,
>> without disabling ACPI altogether), move the "numa=" option handling
>> to common code.
>> 
> 
> I like the idea in general, but I think it may collide with Tejun's NUMA 
> unification patchset for x86, which I assume will another revision once 
> the merge window for .38 closes?  Or maybe he'd like to merge your patch 
> with his series and push it as one?

I would assume that if unification is done, then the command line
option would become common too. Tejun?

However, the problem my patch addresses has been long standing
(I noted it with our .32 based kernel, but according to my looking at
the code it would go back to at least .27), so I'd like to ask for it to
be merged independently (and I should probably have copied stable
too), unless (quite unlikely) Tejun's merge is intended to also be
applied to stable kernels.

Jan

