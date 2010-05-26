Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014Ab0EZJl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 05:41:27 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:32785 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933860Ab0EZJlY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 05:41:24 -0400
MIME-Version: 1.0
In-Reply-To: <1274863655.5882.4875.camel@twins>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	 <201005242049.18920.rjw@sisk.pl> <87wrusvrqe.fsf@deeprootsystems.com>
	 <201005250138.16293.rjw@sisk.pl> <1274863655.5882.4875.camel@twins>
Date: Wed, 26 May 2010 02:41:22 -0700
Message-ID: <AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>, felipe.balbi@nokia.com,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 1:47 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-05-25 at 01:38 +0200, Rafael J. Wysocki wrote:
>> > This of course will lead to a scattering of suspend blockers into any
>> > drivers/subsystems considered "useful", which by looking through current
>> > Android kernels is many of them.
>>
>> That depends on the maintainers of these subsystems, who still have the power
>> to reject requested changes.
>
> So as a scheduler maintainer I'm going to merge a patch that does a
> suspend_blocker when the runqueue's aren't empty... how about that?
>

I don't know if you are serious, since the all the runqueues are never
empty while suspending, this would disable opportunistic suspend
altogether.

-- 
Arve Hjønnevåg
