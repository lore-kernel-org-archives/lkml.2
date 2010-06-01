Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab0FANUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:20:54 -0400
Received: from smtp.adbgroup.pl ([62.29.174.70]:48605 "EHLO smtp.adbgroup.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076Ab0FANUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:20:53 -0400
X-Greylist: delayed 1689 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jun 2010 09:20:53 EDT
Message-ID: <4C05029A.5020000@gmail.com>
Date: Tue, 01 Jun 2010 14:52:42 +0200
From: Lukasz Gromanowski <lgromanowski@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Petr Ovtchenkov <ptr@void-ptr.info>
CC: linux-kernel@vger.kernel.org
Subject: Re: constant half-byte from /proc/sys/kernel/random/uuid
References: <201006011622.58834.ptr@void-ptr.info>
In-Reply-To: <201006011622.58834.ptr@void-ptr.info>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Ovtchenkov pisze:
> Lack of randomness during generating uuid.
> 
> Sample:
> 
> for i in 1 2 3 4 5 6 7 8 9; do cat /proc/sys/kernel/random/uuid ; done
> 
> 3faf5c7e-5e1b-4b3c-a318-979653d85404
> a929d2d3-e229-42ca-9f33-9c09801f41fb
> c2a96cb6-0dba-401c-a9c6-dabe1dec89d6
> df341de3-eb97-4327-bb63-46afd8dbfaa8
> 9d84d61c-0c55-4914-8bd6-7f1601110908
> 6d82e69b-418e-4189-b5a4-0661b6e24dcf
> eb38de66-4e0b-4bd0-827b-e75ba273e85a
> 5585c367-754f-4bbf-81f6-8a728380860d
> c074480b-ad5c-4e10-81d2-82225c449b91
> 
> 
> See on 7th high half-byte: it '4' in
> all cases---4b, 42, 40, 43, 49, 41,
> 4b, 4b, 4e. Checked three comps, with
> similar results. All Linux-generated UUID (boot_id)
> that I see in internet has '4' in this
> half-byte.

Hi,
quote from wikipedia[1]

"Version 4 (random)

Version 4 UUIDs use a scheme relying only on random numbers. This
algorithm sets the version number as well as two reserved bits.
All other bits are set using a random or pseudorandom data source.
Version 4 UUIDs have the form xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
with any hexadecimal digits for x but only one of 8, 9, A, or B for y.
e.g. f47ac10b-58cc-4372-a567-0e02b2c3d479."

[1] http://en.wikipedia.org/wiki/Universally_Unique_Identifier

-- 
best regards,
Lukasz
