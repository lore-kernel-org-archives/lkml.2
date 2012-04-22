Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab2DVMRh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 08:17:37 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:49716 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2DVMRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 08:17:35 -0400
References: <1334267969.2573.14.camel@shrek.rexursive.com> <201204182330.38156.rjw@sisk.pl> <161dc918-dabe-4c26-a25b-772498282722@email.android.com> <201204221347.52883.rjw@sisk.pl>
User-Agent: K-9 Mail for Android
In-Reply-To: <201204221347.52883.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for hibernate/thaw buffering
From: Bojan Smojver <bojan@rexursive.com>
Date: Sun, 22 Apr 2012 22:17:32 +1000
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Per Olofsson <pelle@debian.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Message-ID: <22aaaccf-5898-460c-b1e4-a87c153d9e0c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

>On Sunday, April 22, 2012, Bojan Smojver wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>> 
>> >On Wednesday, April 18, 2012, Bojan Smojver wrote:
>> >> Per Olofsson <pelle@debian.org> wrote:
>> >> 
>> >> >OK, let's say Reviewed-by then.
>> >> >
>> >> >Reviewed-by: Per Olofsson <pelle@debian.org>
>> >> >
>> >> 
>> >> Rafael,
>> >> 
>> >> Anything you still need here?
>> >
>> >No, thanks, I'm going to apply the patch.
>> >
>> >Rafael
>> 
>> Any chance of it in 3.3.3?
>
>Nope.
>
>> Looks like rc1 of it is already out there...
>
>I'm going to push it for v3.5, so it will only appear in 3.4.y I guess.
>
>Thanks,
>Rafael

Don't understand why not. This is a fix for a regression in 3.2 and above. Is there a new policy on regression fixes? I thought this should be queued for 3.4, 3.3 and 3.2. Otherwise, people will continue to see hangs in those versions.

-- 
Bojan
