Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab0JRSVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:21:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47022 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654Ab0JRSVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:21:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=LndABGqVIc/B5EQObezj8BwCTWkFUqkBtzjepi8W2L7dCLKIAAtKCOZ/EOKEUOTpH8
         dKg/HeF4yZB5pPnEUZj01Y3Ugc9LC44egQ7dNM2L0hWPtlMEpEf92hqIpVVmdQhOOO8H
         56E528WwYNF54yj783u/1pgZNyuKrWleS1mOM=
MIME-Version: 1.0
In-Reply-To: <1287413933.29097.1608.camel@twins>
References: <1287302737-3507-1-git-send-email-vapier@gentoo.org>
 <1287303678.20968.37.camel@Joe-Laptop> <AANLkTimmSRS3eVsW4EZUxnE_rfjeqmmgGnjtWbn3J_nY@mail.gmail.com>
 <1287310889.1998.153.camel@laptop> <1287334498.20968.53.camel@Joe-Laptop>
 <1287343839.1998.699.camel@laptop> <AANLkTikaxf-Fh9qUxsXNO5=r+SoxbzYXvCjFcHQLcXjy@mail.gmail.com>
 <1287345710.1998.735.camel@laptop> <AANLkTimixEGQTYrM7ShodtKeC97e0uPNRhWQn8F+-Nui@mail.gmail.com>
 <20101018143935.GA4120@thunk.org> <20101018145400.GD4120@thunk.org> <1287413933.29097.1608.camel@twins>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 18 Oct 2010 14:21:01 -0400
X-Google-Sender-Auth: Zsy4y6IBh3Sue5bmQjLkUEb0fz4
Message-ID: <AANLkTin2joSMdqn_HKzQDHuV5cbwbLAB2hJi7Uj8yEHK@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: allow single space before labels
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 10:58, Peter Zijlstra wrote:
> On Mon, 2010-10-18 at 10:54 -0400, Ted Ts'o wrote:
>> Note that there is absolutely nothing about how labels should be
>> indented in CodingStyle at all, and I very much resist code
>> straightjackets being imposed by checkpatch.pl implementors.
>>
>> Can we please stop this nonsense?
>
> 1) ignoring checkpatch over taste is good
> 2) by 1) its impossible to get checkpatch right
> 3) therefore pure checkpatch patches are nonsense

sounds like an ACK for Joe's patch

Joe: could you post an updated patch ?
-mke
