Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038Ab2CTAhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 20:37:48 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:49866 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759005Ab2CTAhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 20:37:46 -0400
References: <20120309142555.7ec5e0ac@kryten> <1331263785.3105.52.camel@pasglop> <20120309144645.5b5997d2@kryten> <20120309102846.51f0df89@jbarnes-x220> <20120315110516.4112fe49dac537b52d4ddc25@canb.auug.org.au>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120315110516.4112fe49dac537b52d4ddc25@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: 3.3.0-rc6-next-20120308 boot failure on POWER7 blade
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Mon, 19 Mar 2012 17:37:48 -0700
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, yinghai@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Message-ID: <1075f6c8-ed56-45a8-b8ac-fba8fd53a42a@email.android.com>
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 174.234.1.177 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

>Hi Jesse,
>
>On Fri, 9 Mar 2012 10:28:46 -0800 Jesse Barnes
><jbarnes@virtuousgeek.org> wrote:
>>
>> On Fri, 9 Mar 2012 14:46:45 +1100
>> Anton Blanchard <anton@samba.org> wrote:
>> 
>> > > Looks like something that got fixed but the new patches from
>Bjorn
>> > > aren't in next yet. I'll fwd you the patch separately to apply on
>> > > top of what you have see if that helps (to confirm that's indeed
>the
>> > > issue).
>> > 
>> > Thanks, confirmed that it fixes it. Patch below in case anyone else
>is
>> > hitting it.
>> > 
>> > --
>> > 
>> > On Sat, 2012-03-03 at 08:52 +1100, Benjamin Herrenschmidt wrote:
>> > 
>> > > Or give me a chance to dig :-) I'll have a look next week.
>> > 
>> > This is indeed what bjorn suspected on irc, this patch fixes it:
>> > 
>> > (Bjorn, please fold it in the original offending patch)
>> 
>> Thanks guys; I'll push the fixes to -next when I get to a real
>network
>> (at the airport now about to run out of battery with a crappy
>> connection).
>
>Ping?
>
>I am also still carrying the build fix for
>arch/powerpc/kernel/pci-common.c
>since Feb 27.
>
>-- 
>Cheers,
>Stephen Rothwell                    sfr@canb.auug.org.au
>http://www.canb.auug.org.au/~sfr/

Arg yeah I'll apply the fixups before sending the pull req. This trip has been a nightmare (14+ hour work days and no connectivity and a week longer than expected) but it's finally over, and just in time! 

Jesse
-- 
Jesse Barnes, Intel Open Source Technology Center
