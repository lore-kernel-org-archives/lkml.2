Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086Ab0EZJtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 05:49:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46745 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591Ab0EZJtT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 05:49:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=RQRRbQ/pZ2nfT78hN8cRYpRJxNgGtWO6usWdRUwkWoD/CGtgJkZL7MgmnPIdVVnG9
	T4Tx3jnajvQ59XxkPYiZg==
MIME-Version: 1.0
In-Reply-To: <1274867106.5882.5090.camel@twins>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<201005242049.18920.rjw@sisk.pl>
	<87wrusvrqe.fsf@deeprootsystems.com>
	<201005250138.16293.rjw@sisk.pl>
	<1274863655.5882.4875.camel@twins>
	<AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	<1274867106.5882.5090.camel@twins>
Date: Wed, 26 May 2010 02:49:16 -0700
Message-ID: <AANLkTinyVDKriOrSAVV36vwC8Uy26F5WFoNJBv19va5c@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 8)
From: Brian Swetland <swetland@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>, felipe.balbi@nokia.com,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 2:45 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-05-26 at 02:41 -0700, Arve Hjønnevåg wrote:
>> On Wed, May 26, 2010 at 1:47 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Tue, 2010-05-25 at 01:38 +0200, Rafael J. Wysocki wrote:
>> >> > This of course will lead to a scattering of suspend blockers into any
>> >> > drivers/subsystems considered "useful", which by looking through current
>> >> > Android kernels is many of them.
>> >>
>> >> That depends on the maintainers of these subsystems, who still have the power
>> >> to reject requested changes.
>> >
>> > So as a scheduler maintainer I'm going to merge a patch that does a
>> > suspend_blocker when the runqueue's aren't empty... how about that?
>> >
>>
>> I don't know if you are serious, since the all the runqueues are never
>> empty while suspending, this would disable opportunistic suspend
>> altogether.
>
> So why again was this such a great scheme? Go fix your userspace to not
> not run when not needed.


Thanks for your constructive feedback.

Brian
