Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab1CQR6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:58:41 -0400
Received: from b.mail.sonic.net ([64.142.19.5]:48328 "EHLO b.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954Ab1CQR6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:58:39 -0400
X-Greylist: delayed 1177 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Mar 2011 13:58:39 EDT
Message-ID: <4D824721.4020709@twiddle.net>
Date: Thu, 17 Mar 2011 10:38:41 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: Mike Frysinger <vapier@gentoo.org>, libc-alpha@sourceware.org,
        GCC Development <gcc@gcc.gnu.org>, LKML <linux-kernel@vger.kernel.org>,
        x32-abi@googlegroups.com
Subject: Re: X32 psABI status update
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>	<201103160124.42939.vapier@gentoo.org>	<AANLkTim4w7zBBnsu+A1TMtb-wv60urDiSk5T0qbg7Oze@mail.gmail.com>	<201103162257.10440.vapier@gentoo.org> <AANLkTikfiVvxrxakH-_pch6v0jkT1yZstw4kXShyx+Sd@mail.gmail.com>
In-Reply-To: <AANLkTikfiVvxrxakH-_pch6v0jkT1yZstw4kXShyx+Sd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2011 10:21 PM, H.J. Lu wrote:
> On Wed, Mar 16, 2011 at 7:57 PM, Mike Frysinger <vapier@gentoo.org> wrote:
>> On Wednesday, March 16, 2011 08:39:57 H.J. Lu wrote:
>>> On Tue, Mar 15, 2011 at 10:24 PM, Mike Frysinger wrote:
>>>> so we get back to my original e-mail:
>>>>        are you getting a unique host tuple for this ?  or are you
>>>> extending x86_64-linux-gnu ?  so the only way of knowing which ABI is to
>>>> check for the output of the compiler+compiler flags ?
>>>
>>> As I said, the target is x86_64- linux-gnu and you just add -mx32 to
>>> CFLAGS. The x86_64- linux-gnu binutils and GCC support  x32.
>>
>> ok, took long enough, but that answers most things.  your usage of "x32-"
>> prefixed binaries in the documentation seems to imply a lot more than the fact
>> you just picked those locally to avoid system collisions.  this isnt a wiki
>> page, otherwise i'd clean things up for you.
> 
> Any suggestion how to create a wiki page for x32?

Hanging it off of gcc.gnu.org/wiki wouldn't be a bad idea, imo.


r~
