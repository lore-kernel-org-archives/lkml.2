Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2HXSRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:17:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38181 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609Ab2HXSRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:17:31 -0400
Message-ID: <5037C530.3000408@zytor.com>
Date: Fri, 24 Aug 2012 11:17:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: wbrana <wbrana@gmail.com>, Martin Nybo Andersen <tweek@tweek.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Drop support for x86-32
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com> <201208231814.21168.tweek@tweek.dk> <CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com> <CAMzpN2ioV-DjNDKJQwKebSRAuGO=BnYMtutLWPRoUOqx_sA-3g@mail.gmail.com>
In-Reply-To: <CAMzpN2ioV-DjNDKJQwKebSRAuGO=BnYMtutLWPRoUOqx_sA-3g@mail.gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 11:54 AM, Brian Gerst wrote:
> 
>> - wastes time of developers who can spend their time supporting X32
>> instead of x86-32 or support x86-64 only as 99% of users will be able
>> to run x86-64 software if x86-32 will be dropped
> 
> The x86-32 arch is mature and well maintained, and shares so much in
> common with x86-64, that there is little to be gained by dropping
> kernel support.
> 

Speaking as one of the x86 maintainers... we are currently deciding the
cost/benefit tradeoff around removing i386 support.  I don't mean
general x86-32 support, I mean i386 as opposed to i486, Pentium, and so on.

Dropping x86-32 support is decades away.

	-hpa

