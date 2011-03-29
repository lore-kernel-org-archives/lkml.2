Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab1C2S4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 14:56:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57331 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab1C2S4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 14:56:24 -0400
Message-ID: <4D922B35.9050107@kernel.org>
Date: Tue, 29 Mar 2011 11:55:49 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Fainelli <florian@openwrt.org>, x86@kernel.org
Subject: Re: [GIT pull] irq cleanups for .39
References: <alpine.LFD.2.00.1103282048370.2774@localhost6.localdomain6> <AANLkTintrwhwbyZGxX1Eecg9ZXo+NgRzTwyyMyzt1JGR@mail.gmail.com> <alpine.LFD.2.00.1103282210590.2774@localhost6.localdomain6> <alpine.LFD.2.00.1103282227510.2774@localhost6.localdomain6> <AANLkTin7Uc=LzZdD4Waj8GF24Nzi2ccUL+RLtk+fBc=g@mail.gmail.com>
In-Reply-To: <AANLkTin7Uc=LzZdD4Waj8GF24Nzi2ccUL+RLtk+fBc=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2011 03:05 PM, Linus Torvalds wrote:
> On Mon, Mar 28, 2011 at 1:29 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Mon, 28 Mar 2011, Thomas Gleixner wrote:
>>> 2) msg ids are unique and can ge grepped for. also there are archives
>>>    which allow searching for them.
>>>
>>>    http://marc.info?i=alpine.LFD.2.00.1103252150180.31464@localhost6.localdomain6
>>>
>>>    http://mid.gmane.org/alpine.LFD.2.00.1103252150180.31464@localhost6.localdomain6
>>
>> So perhaps we should add one of those into the LKML-Reference and let
>> the commit bot extract the thread reference from there.
> 
> Yes. That would make it something usable to normal users.
> 

My concern with that is that indexing services come and go (and which
ones that offer indexing by message-id, which is the *only* permanent
identifier, are even more subject to change), but things that go into
the git history stays forever.  In IETF terms, the message-id is the
"resource name" (as in URN), as opposed to the "resource locator" (as in
URL).

There is of course the option of running a bounce service on kernel.org,
as long as the Message-ID is included.

	-hpa
