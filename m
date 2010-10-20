Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab0JTUOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 16:14:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47866 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355Ab0JTUOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 16:14:23 -0400
Message-ID: <4CBF4D78.1050404@zytor.com>
Date: Wed, 20 Oct 2010 13:13:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/mm] x86, mm: Fix incorrect data type in vmalloc_sync_all()
References: <20101020103642.GA3135@kryptos.osrc.amd.com> <tip-bfac67208d6d2a84fe7980187d3d2f21424dde59@git.kernel.org> <20101020195046.GB16147@aftab> <4CBF48C7.3050306@linux.intel.com> <20101020201055.GA3971@kryptos.osrc.amd.com>
In-Reply-To: <20101020201055.GA3971@kryptos.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2010 01:10 PM, Borislav Petkov wrote:
> From: "H. Peter Anvin" <hpa@linux.intel.com>
> Date: Wed, Oct 20, 2010 at 12:53:43PM -0700
> 
>> (This is a constant problem, by the way: people seems to want to prefix,
>> not suffix, their commentary; "cover letter" style.)  I suspect git
>> needs to change, but it's hard to know exactly how to change it.
> 
> That's easy, remove the cover letter style when inlining patches further
> down the mail.

The problem is that right now, if there is text like this:

A
---
B

patch

A is retained, and B discarded.  When to discard A and when to discard B
is the hard part.

> But yeah, I'm still trying to decide for me which mail attribution
> format (set attribution="..." in mutt) is better/clearer:
> 
> From: foo
> Date: bar
> 
> or
> 
> On <date>, <person> said:
> 
> Hmm...
> 

Well, the latter can at least be edited out.

The former *really* gunks up git.

	-hpa

