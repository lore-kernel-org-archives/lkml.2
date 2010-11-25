Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab0KYPp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:45:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758Ab0KYPp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:45:56 -0500
Message-ID: <4CEE84B1.4070301@suse.cz>
Date: Thu, 25 Nov 2010 16:45:53 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH 1/5] [PATCH 1/5] kconfig: Make localmodconfig handle environment
 variables
References: <20101029054310.790179545@goodmis.org>	 <20101029054423.498608001@goodmis.org>	 <AANLkTi=a8dp-WUNHAkx2fZ5GgNHmDw+ee7MDeUSL44Z0@mail.gmail.com>	 <1288402042.29632.50.camel@gandalf.stny.rr.com>	 <AANLkTi=JXFppmiyyo=Hc614=FpDhOO4h8SLTs=CUOvQv@mail.gmail.com> <1289263747.12418.78.camel@gandalf.stny.rr.com>
In-Reply-To: <1289263747.12418.78.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9.11.2010 01:49, Steven Rostedt wrote:
> On Sun, 2010-10-31 at 18:05 -0400, Arnaud Lacombe wrote:
>> Hi,
> 
>>> But you are right. After KS and Plumbers, I'll work on doing something
>>> like that. That can probably solve some of the other issues I'm having
>>> (still keeping too many modules enabled).
>>>
>> I have some work in progress in this area: cleanup, better split
>> between the kconfig backend and frontend, and eventually a perl
>> binding. That would all be an interesting goal for .38 :-)
>>
>> Currently I got the parser working within perl, but I'm not really
>> really sure of what I can currently do with it and how the whole thing
>> interface to one another :)
> 
> Let me know what you got, I would really like localmodconfig to have
> this back end. It should really help get a minimal config as well.

What information does localmodconfig need? A list of config options and
their computed dependencies and a flag for each option if it has prompt,
anything else? So a scripts/kconfig/conf --dump-kconfig that would
produce such flat list should suffice, without the complexity of having
to build a perl binding first (and would be usable from bash/awk/python
scripts as well). What do you think?

Michal
