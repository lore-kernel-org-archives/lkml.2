Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0IKA7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 20:59:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57544 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab0IKA7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 20:59:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hAKUVJ+k9BF6FTkZQf+97xOT09PMHXUpkEAYuhNQG3DWdX7ew6GPdglV/3envTc6Az
         6Y9JwPUA+pBTt6wIO5HpovQrI/GR+kGYwzYxDb9/PJlP/NPXwmFVcNrKhKCgwbZtDjnk
         oy57lMBUVVqaDNhhvrJfTZMfTsGmuW5GFgUIs=
MIME-Version: 1.0
In-Reply-To: <1284152491.2681.3.camel@sbsiddha-MOBL3.sc.intel.com>
References: <Pine.LNX.4.64.1009101324280.3056@boston.corp.fedex.com>
	<1284104920.402.21.camel@laptop>
	<AANLkTinBwfLXi0Bv0_gzSWRsdDPzHFQFZFwEYjbwkNs4@mail.gmail.com>
	<1284120353.402.39.camel@laptop>
	<AANLkTikKmsM2kunB_ocwRawLUiuP4-_nz-mPsiapw7TJ@mail.gmail.com>
	<1284150773.402.122.camel@laptop>
	<1284152491.2681.3.camel@sbsiddha-MOBL3.sc.intel.com>
Date: Sat, 11 Sep 2010 08:59:37 +0800
Message-ID: <AANLkTinr-pUYYGhfRoxjN6si294DOBmPrURWD3z+fTU+@mail.gmail.com>
Subject: Re: [PATCH] x86, tsc: Fix a preemption leak in restore_sched_clock_state()
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Nico Schottelius <nico-nospam@schottelius.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Nico Schottelius <nico-linux-20100709@schottelius.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Florian Pritz <flo@xssn.at>, "stable@kernel.org" <stable@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "Brown, Len" <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 11, 2010 at 5:01 AM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Fri, 2010-09-10 at 13:32 -0700, Peter Zijlstra wrote:
>> D'0h !! *facepalm*
>>
>> Shame on me for not spotting that sooner.

It was a hard one to catch.

> Thanks for looking at this and thanks to Jeff for reporting.
>
> Original patch was marked as stable for 2.6.32+, so we need to make sure
> that Greg picks up this piece too along with the original patch.

Verified that it indeed fixed the problem!

Thanks for fixing this.

Jeff
