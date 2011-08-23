Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab1HWQML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:12:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:37471 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab1HWQMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:12:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="41026590"
Message-ID: <4E53D145.7070207@linux.intel.com>
Date: Tue, 23 Aug 2011 09:11:49 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Colin Walters <walters@verbum.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org>	<CA+55aFwEgp=3F6uH198XuQR0=6Um-Kp+0Wjcm0Xv1WoHRveKXw@mail.gmail.com> <CADkLE3Ux1gVBR0f1VUNP4JDsnDQPUQ8rJrXqPV7-2kdLW0_CCw@mail.gmail.com>
In-Reply-To: <CADkLE3Ux1gVBR0f1VUNP4JDsnDQPUQ8rJrXqPV7-2kdLW0_CCw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> A notable one is that Python now reports "linux3" from sys.platform();
> which in turn can break things that were checking sys.platform() ==
> "linux2".
>
> https://bugzilla.mozilla.org/show_bug.cgi?id=664564
>
> Seems pretty clear to me though it's a bug in the apps that are using
> '==' instead of .startswith().

That's a good point. I googled for this pattern in google codesearch
and there are 10+ in the first two pages.

http://www.google.com/codesearch#search/&q=lang:^python$%20sys.platform%20linux2&p=1&type=cs

-andi


