Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab0KYQhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:37:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab0KYQhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:37:31 -0500
Message-ID: <4CEE90C9.8060607@suse.cz>
Date: Thu, 25 Nov 2010 17:37:29 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH 1/5] [PATCH 1/5] kconfig: Make localmodconfig handle environment
 variables
References: <20101029054310.790179545@goodmis.org>	<20101029054423.498608001@goodmis.org>	<AANLkTi=a8dp-WUNHAkx2fZ5GgNHmDw+ee7MDeUSL44Z0@mail.gmail.com>	<1288402042.29632.50.camel@gandalf.stny.rr.com>	<AANLkTi=JXFppmiyyo=Hc614=FpDhOO4h8SLTs=CUOvQv@mail.gmail.com>	<1289263747.12418.78.camel@gandalf.stny.rr.com>	<4CEE84B1.4070301@suse.cz> <AANLkTinZtnyL9CX8yHyXGN6S_2OHSEC-oJ_+eyNRApwE@mail.gmail.com>
In-Reply-To: <AANLkTinZtnyL9CX8yHyXGN6S_2OHSEC-oJ_+eyNRApwE@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.11.2010 17:21, Arnaud Lacombe wrote:
> Hi,
> 
> On Thu, Nov 25, 2010 at 10:45 AM, Michal Marek <mmarek@suse.cz> wrote:
>> What information does localmodconfig need? A list of config options and
>> their computed dependencies and a flag for each option if it has prompt,
>> anything else? So a scripts/kconfig/conf --dump-kconfig that would
>> produce such flat list should suffice, without the complexity of having
>> to build a perl binding first (and would be usable from bash/awk/python
>> scripts as well). What do you think?
>>
> Just as a FYI, the output of zconfdump() does not respect the kconfig
> syntax. I've got some patches to fix that, but I've not been able to
> touch them since a few weeks now.

I'm not saying zconfdump() has to be used or that it has to follow the
kconfig syntax (*), just that a pipe interface between the C kconfig and
a Perl script might be easier to implement and use :-).

(*) Although using a subset of the kconfig syntax would be a good idea
definitely.

Michal
