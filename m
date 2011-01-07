Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1AGKG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 05:06:27 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:40821 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab1AGKG0 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Fri, 7 Jan 2011 05:06:26 -0500
Message-Id: <4D26F3AE020000780002AF5D@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 07 Jan 2011 10:06:22 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "David Rientjes" <rientjes@google.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Tejun Heo" <tj@kernel.org>,
        <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: unify "numa=" command line option handling
References: <4D2603BF020000780002ACA7@vpn.id2.novell.com>
 <alpine.DEB.2.00.1101061235010.30820@chino.kir.corp.google.com>
 <4D26D3FD020000780002AED9@vpn.id2.novell.com>
 <alpine.DEB.2.00.1101070156050.19087@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1101070156050.19087@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.01.11 at 10:58, David Rientjes <rientjes@google.com> wrote:
> On Fri, 7 Jan 2011, Jan Beulich wrote:
> 
>> However, the problem my patch addresses has been long standing
>> (I noted it with our .32 based kernel, but according to my looking at
>> the code it would go back to at least .27), so I'd like to ask for it to
>> be merged independently (and I should probably have copied stable
>> too), unless (quite unlikely) Tejun's merge is intended to also be
>> applied to stable kernels.
>> 
> 
> I don't think this should be targeted to -stable since it's not a bugfix; 
> this is adding a feature that allows you to disable acpi parsing of the 
> SRAT on i386.

How is this not a bug fix if it allows a system to boot that previously
didn't?

Jan

