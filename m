Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab1DHU4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 16:56:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56537 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757948Ab1DHU4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 16:56:10 -0400
Message-ID: <4D9F7630.1090503@zytor.com>
Date: Fri, 08 Apr 2011 13:55:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        x86@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86 APM: delete Linux kernel APM support
References: <alpine.LFD.2.02.1103232321070.3848@x980> <alpine.LFD.2.02.1103241929450.16085@x980> <20110325113048.GC29521@elte.hu> <201103252333.23880.rjw@sisk.pl> <20110408062506.GB1596@ucw.cz>
In-Reply-To: <20110408062506.GB1596@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2011 11:25 PM, Pavel Machek wrote:
>>
>> Well, it kind of does but not really. :-)
>>
>> The main problem with APM is that nobody really works on it and I'm not sure
>> if there are any active users.  At least no one reports any problems with it,
>> which is kind of surprising, given the number of chages we've made in the PM
>> core for the last couple of years.  So quite likely it's just become
>> non-functional over time anyway, but we have no confirmation.
> 
> It was working ok last time I tried -- cca 6/2010.
> 								Pavel

What aspects of it did you test, and on what platform?

	-hpa

