Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab2DQDkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 23:40:00 -0400
Received: from 066-241-084-054.bus.ashlandfiber.net ([66.241.84.54]:39841 "EHLO
	bigred.russwhit.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754706Ab2DQDjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 23:39:54 -0400
Date: Mon, 16 Apr 2012 20:38:53 -0700 (PDT)
From: Russell Whitaker <russ@ashlandhome.net>
X-X-Sender: russ@bigred.russwhit.org
To: Ken Moffat <zarniwhoop@ntlworld.com>
cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: default framebuffer
In-Reply-To: <20120416220249.GA25109@milliways>
Message-ID: <alpine.LNX.2.00.1204162030370.1631@bigred.russwhit.org>
References: <alpine.LNX.2.00.1204152129060.2200@bigred.russwhit.org> <20120416140443.GA1153@elliptictech.com> <20120416220249.GA25109@milliways>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463798188-1806512402-1334633934=:1631"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463798188-1806512402-1334633934=:1631
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT



On Mon, 16 Apr 2012, Ken Moffat wrote:

> On Mon, Apr 16, 2012 at 10:04:43AM -0400, Nick Bowler wrote:
>> Hi Russell,
>>
>> On 2012-04-15 21:37 -0700, Russell Whitaker wrote:
>>>
>>> What should I do to keep the screen at 80x25?
>>
>> Load a bigger console font.  For example, the Terminus font package
>> http://terminus-font.sourceforge.net/ includes some nice console fonts
>> in a variety of sizes.  Try
>>
>>   setfont ter-132b
>>
>> to start.  Your distribution probably provides a convenient way to set
>> the console font at boot.
>>
>> Hope that helps,
>
> Alternatively, add video=something to the commandline in your
> bootloader.  I've got a 1600x1200 screen.  On some machines I use my
> 12x22 font, on the others I use my 8x16 font with video=1024x768 ¹
> Oh, and on my netbook I use the 12x22 for something like 95x30.  But
> I also guess that exactly 80x25 is not necessarily critical,
> provided the characters are legible.
>
> I've no idea which video= values work, and I'm using a lot more
> than 80x25, but perhaps video=800x600 or video=640x480 (assuming, of
> course, that you have a 4:3 screen and not the now-common 16:10)
> with a small font will be in the right area.

Just now put video=640x480 in grub's menu.lst and I got a 80x30 screen.
That's satisfactory, howeber will also try the larger font suggestion, 
too.

Thanks guys
    Russ
>
> ¹ LatGrkCyr - they are in kbd as of 1.15.3, but there's no telling
> whether you will like it - people using a light background almost
> certainly will hate it.
>
> ken
> -- 
> das eine Mal als Tragödie, das andere Mal als Farce
>
---1463798188-1806512402-1334633934=:1631--
