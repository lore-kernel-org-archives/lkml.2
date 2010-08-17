Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab0HQTt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 15:49:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32584 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0HQTty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 15:49:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=K6kZg82TvboyMLhVaEs1BCP+ogVS2lFi/5D0HskxrCBkPnw3WeuvJzDJ+TRkL/i9J
	Fi/cSb+Mea2uvrhch97/g==
MIME-Version: 1.0
In-Reply-To: <1282060094.1926.3038.camel@laptop>
References: <1281957914.1926.1249.camel@laptop>
	<20100816182834.3541.42317.stgit@bumblebee1.mtv.corp.google.com>
	<20100817152352.GA10785@amd>
	<1282060094.1926.3038.camel@laptop>
Date: Tue, 17 Aug 2010 12:49:51 -0700
Message-ID: <AANLkTinodHja9Dth1-p5B2Y5P9UkUKw8YnwRZ+E+Rxr-@mail.gmail.com>
Subject: Re: [PATCH] Fixed a mismatch between the users of radix_tree and the implementation.
From: Salman Qazi <sqazi@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, paulmck@us.ibm.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        adurbin@google.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 8:48 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-08-18 at 01:23 +1000, Nick Piggin wrote:
>> How about something like this?
>
> Ah, very nice indeed. Looks like it will indeed close the hole.
>
> Thanks Nick!
>

I like Nick's patch in principle.  I will try it out to verify that it
fixes the problem (although, reading it, I am fairly certain that it
does).
