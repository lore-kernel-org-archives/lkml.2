Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab1BJIrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 03:47:39 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:50551 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1BJIri convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Thu, 10 Feb 2011 03:47:38 -0500
Message-Id: <4D53B45C0200007800031313@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 10 Feb 2011 08:48:12 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Tim Deegan" <Tim.Deegan@citrix.com>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>, <akpm@linux-foundation.org>,
        "Jiri Slaby" <jslaby@suse.cz>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix jiffy calculations in calibrate_delay_direct
	 to handle overflow
References: <4D525EF00200007800030F0F@vpn.id2.novell.com>
 <AANLkTinu3q==3kAaXkUBorOX7NG49w+X77ZZQifhhJ+Z@mail.gmail.com>
In-Reply-To: <AANLkTinu3q==3kAaXkUBorOX7NG49w+X77ZZQifhhJ+Z@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 09.02.11 at 21:54, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, Feb 9, 2011 at 12:31 AM, Jan Beulich <JBeulich@novell.com> wrote:
>> Fixes a hang when booting as dom0 under Xen, when jiffies can be
>> quite large by the time the kernel init gets this far.
>>
>> Signed-off-by: Tim Deegan <Tim.Deegan@citrix.com>
>>
>> !time_after() -> time_before_eq() as per suggestion from Jiri Slaby.
>>
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>> Cc: Jiri Slaby <jslaby@suse.cz>
>> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> 
> So I have nothing against the patch, but the changelog is broken.
> 
> Is Tim the original author? If so, why wasn't that noted? I'm just
> guessing from that random signed-off line in the middle of the thing.

Indeed, I forgot to add the From: line. I'm sorry about that; I'll
resubmit.

Jan

