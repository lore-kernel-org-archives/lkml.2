Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab0L2PDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 10:03:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40724 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab0L2PDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 10:03:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iTuQ4SptesN8qptoVqo98W/eE/CIag0rRumpMV9GAI2x4GexN5+htrQFeVS3kGSJdc
         okKxffXCm5C00Srfd3zgb1VRalfCypIA2W5dtJkedksAxmOXEuWGC9qvz+cxHCoP7TNM
         aygVabtcZN4bugHsbETM+GgAsnvlaR4yL2Gjk=
MIME-Version: 1.0
In-Reply-To: <1293634687.4128.10.camel@m0nster>
References: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com>
	<201012272215.52642.arnd@arndb.de>
	<1293551490.24601.10.camel@m0nster>
	<201012291247.27663.arnd@arndb.de>
	<AANLkTikGe3D-ujM9jqcOtk1cGmtLtUiV3kMkam1N8fyM@mail.gmail.com>
	<1293634687.4128.10.camel@m0nster>
Date: Wed, 29 Dec 2010 23:03:14 +0800
Message-ID: <AANLkTi=0yNQkL3WSP-_GHTEwSb9KuBQmSxC006k-AxDe@mail.gmail.com>
Subject: Re: [PATCH v0] add nano semaphore in kernel
From: Hillf Danton <dhillf@gmail.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Mike Christie <michaelc@cs.wisc.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 10:58 PM, Daniel Walker <dwalker@codeaurora.org> wrote:
> On Wed, 2010-12-29 at 22:42 +0800, Hillf Danton wrote:
>> On Wed, Dec 29, 2010 at 7:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Tuesday 28 December 2010 16:51:30 Daniel Walker wrote:
>> >> We for sure don't want new semaphores, or new semaphore usage in the
>> >> kernel ..
>>
>> Would you please, Daniel, explain why there are so my file systems under
>> the fs directory? Would you think the ext file system is better than others?
>>
>> And why there are in kernel spin lock, read/write lock, mutex, rw_mutex,
>> rtmutx, and semaphore, timer and hrtimer?
>>
>> Could timer be removed tonight?
>
> The problem with semaphores is that people use them in ways that are not
> very nice, and not very efficient.. Since they are so flexible they can
> be used in all sorts of ways, many of which are not clean. This is why,
> if you read the kernel history, most semaphore have been removed from
> the kernel and replaced with much nicer and cleaner mutexes.
>
> Daniel

Thanks for sharing the knowledge about rtmutx and semaphore.
Hillf
