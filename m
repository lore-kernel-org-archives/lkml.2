Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068Ab0JZQqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:46:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55986 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab0JZQqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:46:53 -0400
Message-ID: <4CC705ED.1020105@zytor.com>
Date: Tue, 26 Oct 2010 09:46:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: kvm@vger.kernel.org, avi@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: fyi: gcc33-hammer crashes when compiling kvm emulate.c
References: <20101026123828.GA30434@basil.fritz.box> <4CC70333.80400@zytor.com> <20101026163748.GB29961@basil.fritz.box>
In-Reply-To: <20101026163748.GB29961@basil.fritz.box>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2010 09:37 AM, Andi Kleen wrote:
>> We have said 3.4 minimum for x86 for a long time now, and have an RFC
> 
> Ok makes sense. I thought it was still at 3.3. I should retire
> this 3.3 fossil anyways, it's really only for old compat testing.
> 
> I don't remember seeing a warning -- aren't there supposed to be warnings
> for unsupported compilers?
> 

Not unless they are actively known to break.  People get huffy about it
because even if it is known to have problems it doesn't break *their*
particular configuration.  I'm getting to be of the opinion that people
who compile modern kernels with ancient compilers and expect it to work
are suffering from some particular kind of insanity -- it's nothing the
distros do.  The only exception are embedded people who compile with the
latest 3.4 gcc; they have explained they do so because newer gccs have
too many dependencies (the actual compiler, not the generated code) and
for speed.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

