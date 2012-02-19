Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab2BSXV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 18:21:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54423 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2BSXV2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 18:21:28 -0500
MIME-Version: 1.0
In-Reply-To: <4F413B8D.5080307@xenotime.net>
References: <4F3E42E0.4030108@openvz.org>
	<20120217120815.25909.15632.stgit@zurg>
	<20120217123037.ecfc5dd9.akpm@linux-foundation.org>
	<CAMuHMdUYCGoZoUHWMtMCwAJ2ofweaeLF3U89P5EvrNGcn=6apw@mail.gmail.com>
	<4F413B8D.5080307@xenotime.net>
Date: Sun, 19 Feb 2012 18:21:26 -0500
Message-ID: <CACqU3MUOojw0pwzOpPFB9YvA=BLODe+idWkqwA7NUAm-9114Rw@mail.gmail.com>
Subject: Re: [PATCH] mm: add config NUMA stub to all architectures
From: Arnaud Lacombe <lacombar@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Feb 19, 2012 at 1:12 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 02/19/2012 09:01 AM, Geert Uytterhoeven wrote:
>>
>> On Fri, Feb 17, 2012 at 21:30, Andrew Morton<akpm@linux-foundation.org>
>>  wrote:
>>>
>>> On Fri, 17 Feb 2012 16:08:15 +0400
>>> Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>>>
>>>> Config NUMA must be defined for all architectures,
>>>> otherwise IS_ENABLED(CONFIG_NUMA) does not work.
>>>> Some arch-specific Kconfig already has this stub.
>>>> This patch adds it to all remaining.
>>>
>>>
>>> It would be better to teach IS_ENABLED() to handle this situation.  I
>>> don't think there's a way of doing this with cpp :(
>>>
>>> This limitation makes IS_ENABLED pretty dangerous, doesn't it?  It
>>> makes it very easy to introduce build breakage with unexpected Kconfig
>>> combinations.
>>
>>
>> Indeed. Recently I discovered IS_ENABLED() and started recommending it
>> to people for new code. But now I've seen the CONFIG_NUMA breakage,
>> I no longer think this is a good recommendation.
>
> adding Michal & linux-kbuild to cc: list.
>
I do not really see any way to fix this, beside having a unique
architecture-wide configuration namespace :/

 - Arnaud
