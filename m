Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1AZTdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:33:21 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:50570 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754038Ab1AZTdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:33:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAL0FQE1Ld/sX/2dsb2JhbAAMhAbNb5EDgSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,381,1291611600"; 
   d="scan'208";a="89334533"
Message-ID: <4D4076FD.6070207@teksavvy.com>
Date: Wed, 26 Jan 2011 14:33:17 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3E59CA.6070107@teksavvy.com> <4D3E5A91.30207@teksavvy.com> <20110125053117.GD7850@core.coreip.homeip.net> <4D3EB734.5090100@redhat.com> <20110125164803.GA19701@core.coreip.homeip.net> <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com> <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D403855.4050706@teksavvy.com> <4D405A9D.4070607@redhat.com>
In-Reply-To: <4D405A9D.4070607@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-26 12:32 PM, Mauro Carvalho Chehab wrote:
> Em 26-01-2011 13:05, Mark Lord escreveu:
..
>> Nope. Does not work here:
>>
>> $ lsinput
>> protocol version mismatch (expected 65536, got 65537)
> 
> You need to relax the version test at the tree. As I said before, this is
> a development tool from the early RC days, bound to work with one specific
> version of the API, and programmed by purpose to fail if there would by any
> updates at the Input layer.
..

As I said before, I personally have done that on my copy here.
But that's not what this thread is about.

This thread is about broken userspace courtesy of these changes.
So I am testing with the original userspace binary here,
and it still fails.  And will continue to fail until that regression is fixed.

Cheers
