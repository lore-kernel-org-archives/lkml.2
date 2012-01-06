Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030298Ab2AFKV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 05:21:57 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:50198 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030200Ab2AFKVy convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 6 Jan 2012 05:21:54 -0500
Message-Id: <4F06AF4A020000780006AC14@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 06 Jan 2012 07:22:34 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andi Kleen" <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: x86-64: memset()/memcpy() not fully standards compliant
References: <4F05BBFE020000780006A983@nat28.tlf.novell.com>
 <20120105182846.GQ11715@one.firstfloor.org> <4F0630CC.7050001@zytor.com>
 <20120106014748.GS11715@one.firstfloor.org> <4F06566B.8080708@zytor.com>
In-Reply-To: <4F06566B.8080708@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.01.12 at 03:03, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 01/05/2012 05:47 PM, Andi Kleen wrote:
>>>
>>> Is that still true, and do we even use string instructions still on
>>> those old CPUs?  Jan's fixes don't introduce any additional delays in
>>> the non-string-instruction paths.
>> 
>> Yes various of the CPUs with bugs used string instructions.
>> 
> 
> Which CPUs are you talking about here?

Indeed, I went through various specification updates/revision guides
without finding any relevant erratum.

>> 
>> Both string and non string instructions are used on modern CPUs,
>> so making any of that slower is not a good idea.
>> 
> 
> Obviously not, but I'm perfectly fine turning REP_GOOD off on old broken
> CPUs.

Yes, that's what my plan would have been too, had I been able to
identify any specific CPU(s) that actually suffer from such problems.

Jan

