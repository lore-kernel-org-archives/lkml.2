Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab0I3NXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 09:23:24 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:6533 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab0I3NXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 09:23:23 -0400
Message-ID: <4CA48F47.5020101@tilera.com>
Date: Thu, 30 Sep 2010 09:23:19 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: <linasvepstas@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, GLIBC Devel <libc-alpha@sourceware.org>,
        <linux-kernel@vger.kernel.org>, <libc-ports@sourceware.org>
Subject: Re: asm-generic/unistd.h and glibc use of NR_ipc
References: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com> <201009281040.09728.arnd@arndb.de> <4CA1E809.5010103@tilera.com> <AANLkTik4K+P_3pzN3g4_1UBnOVWTHLmRwFoHLKOS018T@mail.gmail.com>
In-Reply-To: <AANLkTik4K+P_3pzN3g4_1UBnOVWTHLmRwFoHLKOS018T@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 9/28/2010 1:36 PM, Linas Vepstas wrote:
> On 28 September 2010 08:05, Chris Metcalf <cmetcalf@tilera.com> wrote:
>> On 9/28/2010 4:40 AM, Arnd Bergmann wrote:
>>> Chris Metcalf is using the generic unistd.h file on the tile architecture
>>> and has a glibc port that should be easily portable to all future
>>> architectures. There are a few of them getting ready to be merged
>>> now (c6x, lm32, nios2, and some people have contacted me privately
>>> for architectures I cannot name).
>>>
>> I'm happy to provide some previews of the work I'm doing to interested parties.
> Yes, this is exactly what I'm looking for!  I'd love to "preview" the
> code; it'll take a good long while to get everything built and tested,
> so feeback might take a while ...
>
> Any chance that these could be split out as a distinct set of patches,
> taken apart from the tilera arch port, and submitted upstream
> independently (to glibc and/or ports collection)?  I'll help w/ patch
> preparation...

At this point I'm probably a week away from having something with the
obvious bugs all fixed, at which point I can start submitting it back
upstream.  The few patches I have to common infrastructure I'll just submit
to libc-alpha as git patches, then I'll probably just send a two-part patch
set to libc-ports, one with the linux/generic stuff, and one with the
tile-specific stuff.  (It looks like changes are never made as "git pull"
requests on the glibc lists, just as emailed unidiffs -- someone correct me
if I'm wrong.)

Linas, if you can wait a week I'd rather have you see the stuff I believe
to be working 100% to get maximum use out of you as a reviewer :-)  If you
need it sooner, of course, I'm happy to let you have something now.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

