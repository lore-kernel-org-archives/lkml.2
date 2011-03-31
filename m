Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab1CaCgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 22:36:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41823 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab1CaCgw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 22:36:52 -0400
References: <201103292143.12777.rjw@sisk.pl> <201103302355.38136.rjw@sisk.pl> <AANLkTiksT50imm3yQJPrRTqp732=jNYqnNdyvGhGbyHQ@mail.gmail.com> <201103310039.34128.rjw@sisk.pl>
In-Reply-To: <201103310039.34128.rjw@sisk.pl>
Mime-Version: 1.0 (iPhone Mail 8G4)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <8573226D-5C3D-4227-B78D-CAC6C898192B@cs.ubc.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Shriram Rajagopalan <rshriram@cs.ubc.ca>,
        LKML <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>
X-Mailer: iPhone Mail (8G4)
From: Shriram Rajagopalan <rshriram@cs.ubc.ca>
Subject: Re: [GIT PULL] Power management Kconfig modification for 2.6.39
Date: Wed, 30 Mar 2011 22:36:46 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Shriram

On 2011-03-30, at 6:39 PM, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Thursday, March 31, 2011, Linus Torvalds wrote:
>> On Wed, Mar 30, 2011 at 2:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> That, in fact, is not necessary.  Moreover, it turns out that the patch size
>>> is not much different, because only a few subsystems use CONFIG_HIBERNATION
>>> directly.
>>> 
>>> The patch below has only been slightly tested, in particular I'd like the Xen
>>> people to check if it works for them.
>> 
>> Ok, this seems to make much more sense. Just from a quick scan, the
>> places where you changed things to
>> 
>>  #ifdef CONFIG_HIBERNATE_CALLBACKS
>> 
>> really do seem to be about the freeze/thaw callbacks. So now the patch
>> looks more logical to me. And it obviously doesn't change the
>> user-visible questions.
>> 
>> Thank you,
> 
> Thanks for the review!
> 
> @Shriram: Can you please test if the new patch works with your other Xen
> patches?
> 
> Rafael
> 
