Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab0LWMxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 07:53:14 -0500
Received: from mx2.compro.net ([12.186.155.4]:16000 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab0LWMxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 07:53:13 -0500
X-IronPort-AV: E=Sophos;i="4.60,219,1291611600"; 
   d="scan'208";a="6165960"
Message-ID: <4D134637.9020709@compro.net>
Date: Thu, 23 Dec 2010 07:53:11 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel@daenzer.net>
CC: dmarkh@cfl.rr.com, Andrew Morton <akpm@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: VERY slow scrolling on radeon graphics card: debugging a timing
 issue?
References: <4D0FC36D.9010304@msgid.tls.msk.ru>	 <20101222020041.c168bf87.akpm@linux-foundation.org>	 <4D11D939.9080808@cfl.rr.com> <1293089117.19556.109.camel@thor.local>
In-Reply-To: <1293089117.19556.109.camel@thor.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2010 02:25 AM, Michel Dänzer wrote:
> On Mit, 2010-12-22 at 05:55 -0500, Mark Hounschell wrote: 
>>
>> I also see this very problem on several machines I have with radeon video.
>> For me the worst part is using vi in a konsole. Moving the cursor around
>> is so slow that I just can't use these machines directly and have to ssh
>> into them from another machine just to work on them.
> 
> That's not the same problem as the one described by Michael, which is
> about the console on virtual terminals different from X.
> 
> For your problem, try choosing a different font (a fontconfig one
> instead of a legacy X one) in konsole.
> 
> 

Hum, but I do in fact see the same thing he sees on a VT. A dmesg
command from a VT  takes around 20 seconds to display. The same in a
konsole takes a fraction of a second.
So your probably right that my vi problem in a konsole is a different
issue. I do see the same thing as the OP does though. I just figured
they were probably related.

Changing fonts doesn't change anything though. I normally use the "Misc
Console" font FWIW.

Regards
Mark

