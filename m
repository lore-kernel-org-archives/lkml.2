Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479Ab0JZSTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 14:19:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33597 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933445Ab0JZSTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 14:19:30 -0400
Message-ID: <4CC71B94.2010802@zytor.com>
Date: Tue, 26 Oct 2010 11:19:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: kvm@vger.kernel.org, avi@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: fyi: gcc33-hammer crashes when compiling kvm emulate.c
References: <20101026123828.GA30434@basil.fritz.box> <4CC70333.80400@zytor.com> <20101026163748.GB29961@basil.fritz.box> <4CC705ED.1020105@zytor.com> <20101026170142.GD29961@basil.fritz.box>
In-Reply-To: <20101026170142.GD29961@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2010 10:01 AM, Andi Kleen wrote:
>> Not unless they are actively known to break.  People get huffy about it
> 
> Well they do -- i just found out.

Sounds like a good reason to put in a warning or error.

>> because even if it is known to have problems it doesn't break *their*
>> particular configuration.  I'm getting to be of the opinion that people
>> who compile modern kernels with ancient compilers and expect it to work
>> are suffering from some particular kind of insanity -- it's nothing the
>> distros do.  The only exception are embedded people who compile with the
>> latest 3.4 gcc; they have explained they do so because newer gccs have
>> too many dependencies (the actual compiler, not the generated code) and
>> for speed.
> 
> At least in the old days the main reason for gcc 3 was build speed.
> AKPM and some others used to be fond of that.
> 
> 3.x is apparently much faster than 4.x

That is an issue too, as 3.x does a lot fewer optimizations than 4.x.

	-hpa
