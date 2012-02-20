Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab2BTOYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 09:24:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab2BTOYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 09:24:35 -0500
Message-ID: <4F42579F.5070701@suse.cz>
Date: Mon, 20 Feb 2012 15:24:31 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] mm: add config NUMA stub to all architectures
References: <4F3E42E0.4030108@openvz.org> <20120217120815.25909.15632.stgit@zurg> <20120217123037.ecfc5dd9.akpm@linux-foundation.org> <CAMuHMdUYCGoZoUHWMtMCwAJ2ofweaeLF3U89P5EvrNGcn=6apw@mail.gmail.com> <4F413B8D.5080307@xenotime.net> <CACqU3MUOojw0pwzOpPFB9YvA=BLODe+idWkqwA7NUAm-9114Rw@mail.gmail.com>
In-Reply-To: <CACqU3MUOojw0pwzOpPFB9YvA=BLODe+idWkqwA7NUAm-9114Rw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.2.2012 00:21, Arnaud Lacombe wrote:
> On Sun, Feb 19, 2012 at 1:12 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> On 02/19/2012 09:01 AM, Geert Uytterhoeven wrote:
>>>
>>> On Fri, Feb 17, 2012 at 21:30, Andrew Morton<akpm@linux-foundation.org>
>>>  wrote:
>>>> It would be better to teach IS_ENABLED() to handle this situation.  I
>>>> don't think there's a way of doing this with cpp :(
>>>>
>>>> This limitation makes IS_ENABLED pretty dangerous, doesn't it?  It
>>>> makes it very easy to introduce build breakage with unexpected Kconfig
>>>> combinations.
>>>
>>>
>>> Indeed. Recently I discovered IS_ENABLED() and started recommending it
>>> to people for new code. But now I've seen the CONFIG_NUMA breakage,
>>> I no longer think this is a good recommendation.
>>
>> adding Michal & linux-kbuild to cc: list.
>>
> I do not really see any way to fix this, beside having a unique
> architecture-wide configuration namespace :/

Having a single namespace, or less ambitiously, having less
arch-specific config symbol definitions, would be a plus. IS_ENABLED
requiring the symbol to be defined is not bad per se, it prevents typos.

Michal
