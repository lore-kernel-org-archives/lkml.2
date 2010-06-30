Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab0F3RNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 13:13:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42786 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756921Ab0F3RNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 13:13:36 -0400
Message-ID: <4C2B7B28.1000506@zytor.com>
Date: Wed, 30 Jun 2010 10:13:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: jeremy.fitzhardinge@citrix.com, mingo@elte.hu, tglx@linutronix.de,
       Ky Srinivasan <KSrinivasan@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4, v2] x86: enlightenment for ticket spin locks -	 eliminate
 NOPs introduced by first patch
References: <4C2A205902000078000089E7@vpn.id2.novell.com> <4C2A9A1E.6010005@zytor.com> <4C2B09450200007800008B95@vpn.id2.novell.com>
In-Reply-To: <4C2B09450200007800008B95@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 12:07 AM, Jan Beulich wrote:
>>
>> If you're stretching (bloating) them anyway, perhaps we should be using
>> "add" instructions instead, with their better EFLAGS behavior?
> 
> Hmm, yes, that possibility I didn't even consider. Would have
> the potential to get away without that admittedly ugly "unary"
> assembler macro altogether, though at the price of growing all
> instructions rather than just those that have a non-symbolic
> and small displacement. Since unlock generally gets inlined, I'm
> not certain this additional growth in code size would be
> acceptable...
> 
> Please let me know, though before submitting an eventual third
> version I'd appreciate knowing especially the first two patches
> need further changes in order to get accepted.
> 

Will look at it today, hopefully.  The Syslinux 4.00 release has
unfortunately occupied me over the last week-plus.

As far as the "unary" macro is concerned... I have to admit I couldn't
even figure out what it was supposed to do.  It could definitely use a
better comment.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

