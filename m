Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab2BSSMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 13:12:33 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:33826 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754541Ab2BSSMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 13:12:31 -0500
Message-ID: <4F413B8D.5080307@xenotime.net>
Date: Sun, 19 Feb 2012 10:12:29 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] mm: add config NUMA stub to all architectures
References: <4F3E42E0.4030108@openvz.org>	<20120217120815.25909.15632.stgit@zurg>	<20120217123037.ecfc5dd9.akpm@linux-foundation.org> <CAMuHMdUYCGoZoUHWMtMCwAJ2ofweaeLF3U89P5EvrNGcn=6apw@mail.gmail.com>
In-Reply-To: <CAMuHMdUYCGoZoUHWMtMCwAJ2ofweaeLF3U89P5EvrNGcn=6apw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2012 09:01 AM, Geert Uytterhoeven wrote:
> On Fri, Feb 17, 2012 at 21:30, Andrew Morton<akpm@linux-foundation.org>  wrote:
>> On Fri, 17 Feb 2012 16:08:15 +0400
>> Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>>
>>> Config NUMA must be defined for all architectures,
>>> otherwise IS_ENABLED(CONFIG_NUMA) does not work.
>>> Some arch-specific Kconfig already has this stub.
>>> This patch adds it to all remaining.
>>
>> It would be better to teach IS_ENABLED() to handle this situation.  I
>> don't think there's a way of doing this with cpp :(
>>
>> This limitation makes IS_ENABLED pretty dangerous, doesn't it?  It
>> makes it very easy to introduce build breakage with unexpected Kconfig
>> combinations.
>
> Indeed. Recently I discovered IS_ENABLED() and started recommending it
> to people for new code. But now I've seen the CONFIG_NUMA breakage,
> I no longer think this is a good recommendation.


adding Michal & linux-kbuild to cc: list.

-- 
~Randy
