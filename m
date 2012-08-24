Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954Ab2HXRZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 13:25:59 -0400
Received: from exprod7og101.obsmtp.com ([64.18.2.155]:42125 "EHLO
	exprod7og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759938Ab2HXRZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 13:25:56 -0400
Message-ID: <5037B8FD.9060604@genband.com>
Date: Fri, 24 Aug 2012 11:25:17 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: wbrana <wbrana@gmail.com>
CC: Martin Nybo Andersen <tweek@tweek.dk>,
        Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Drop support for x86-32
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com>	<201208241814.16862.tweek@tweek.dk>	<5037AAB0.6040102@genband.com>	<201208241854.45656.tweek@tweek.dk> <CAJ7jCmkiPrr3-pf2yspNiHHzhZBCsuWZaTRCjmi_wSdBGhB6Fg@mail.gmail.com>
In-Reply-To: <CAJ7jCmkiPrr3-pf2yspNiHHzhZBCsuWZaTRCjmi_wSdBGhB6Fg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Aug 2012 17:25:21.0362 (UTC) FILETIME=[7050D320:01CD821D]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19136.000
X-TM-AS-Result: No--1.208800-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 11:05 AM, wbrana wrote:
> On 8/24/12, Martin Nybo Andersen<tweek@tweek.dk>  wrote:
>> What I'd hate even more is rendering my old working hardware useless by
>> removing x86-32 support from the kernel. To reason the removal by saying
>> "Microsoft plans to do it" just makes me go bonkers...

> Your old hardware will work fine with long term kernel.

Give it up.  x86-32 support isn't going away for a long time.

The kernel exists to support existing hardware, not the other way 
around.  As long as people want to keep using x86-32 on linux, it will 
continue to be supported.

Chris
