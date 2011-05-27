Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1E0RVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:21:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752032Ab1E0RVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:21:54 -0400
MIME-Version: 1.0
In-Reply-To: <20110527171611.GE4356@elte.hu>
References: <1306269105.21443.20.camel@dan> <201105270018.36835.rjw@sisk.pl>
 <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com> <20110527170045.GB4356@elte.hu>
 <1306516230.3339.17.camel@dan> <20110527171611.GE4356@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 May 2011 10:21:03 -0700
Message-ID: <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
To: Ingo Molnar <mingo@elte.hu>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 10:16 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Well, 'fixing the info leaks' will obfuscate previously useful files
> such as /proc/kallsyms ...

Guys, stop with the crazy already.

YOU HAVE TO DO THAT FOR THE LINK-TIME-OBFUSCATION TOO!

> That's one of the advantages of randomization: it allows us to expose
> RIPs without them being an instant information leak.

Except you clearly aren't thinking that through AT ALL.

The obfuscation of things like /proc/kallsyms is *exactly*the*same*
whether you do the randomization at boot-time or install-time.

For chrissake - you're doing the same thing. The only question is
"when" (and the fact that if you do it at install-time, you can do a
fancier job of it)

Stop wasting peoples time with idiocies, please.

                    Linus
