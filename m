Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab1E1Avl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 20:51:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54311 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757615Ab1E1Avl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 20:51:41 -0400
Message-ID: <4DE046D9.7050700@zytor.com>
Date: Fri, 27 May 2011 17:50:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Olivier Galibert <galibert@pobox.com>
CC: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
References: <1306269105.21443.20.camel@dan> <201105270018.36835.rjw@sisk.pl> <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com> <20110527170045.GB4356@elte.hu> <1306516230.3339.17.camel@dan> <20110527171611.GE4356@elte.hu> <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com> <20110527174644.GG4356@elte.hu> <BANLkTimGQh7P9O+BEd85Wm5iqzWg5DuYYg@mail.gmail.com> <20110527181724.GA6485@elte.hu> <20110527215123.GA45133@dspnet.fr>
In-Reply-To: <20110527215123.GA45133@dspnet.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2011 02:51 PM, Olivier Galibert wrote:
> On Fri, May 27, 2011 at 08:17:24PM +0200, Ingo Molnar wrote:
>>  - A root exploit will still not give away the location of the
>>    kernel (assuming module loading has been disabled after bootup),
>>    so a rootkit cannot be installed 'silently' on the system, into
>>    RAM only, evading most offline-storage-checking tools.
>>
>>    With static linking this is not possible: reading the kernel image
>>    as root trivially exposes the kernel's location.
> 
> There's something I don't get there.  If you managed to escalate your
> priviledges enough that you have physical ram access, there's a
> billion things you can do to find the kernel, including vector
> tracing, pattern matching, looking at the page tables, etc.
> 
> What am I missing?
> 

Just makes it harder to automate an attack, and more likely that it will
fail.  It's an arms race, of course.

	-hpa
