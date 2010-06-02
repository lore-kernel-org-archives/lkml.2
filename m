Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab0FBQK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 12:10:26 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57953 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932680Ab0FBQKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 12:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rj3Jg2Gjjfg6LVxCvjJ3GsfY6wFDC6tNmf3ZE8MORFL5bKyxEhtaRwBOuBhWmABZlo
         pgl0W2v0hXmRKCoWxHTKRWsqgaedQiT7JxP1saECl1IVMKmnBzi2NFcvSZRS9mLRGoF+
         84j1OILlMTJJoM18ndvqQyEAHKBbN2HStVawY=
MIME-Version: 1.0
In-Reply-To: <20100602085748.6771e025.randy.dunlap@oracle.com>
References: <AANLkTikC61Y9g-WbqwgGDghDSy2XtgraFSRoZYkHRGTG@mail.gmail.com>
	<AANLkTilEYHVHJrj_KgF48OYCSEUcsKLi57Q_Y73d9va-@mail.gmail.com>
	<20100602085748.6771e025.randy.dunlap@oracle.com>
Date: Wed, 2 Jun 2010 21:40:23 +0530
Message-ID: <AANLkTikYYVh0S2l884s_u3efl-b413YhoNttjOJGKsrt@mail.gmail.com>
Subject: Re: make ARM=arm menuconfig problem in mainline
From: Nobin Mathew <nobin.mathew@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when I go to select ARM system
type(OMAP, Davinci etc), I am not seeing any entries there in the pop
up window. When I remove  bool "Samsung S3C2410, S3C2412, S3C2413,
S3C2416, S3C2440,
>> S3C2442, S3C2443, S3C2450"  it is working fine. I feel it is something to do with length of that string.

Is it possible to attach screenshots in this list?

Thanks
Nobin

On Wed, Jun 2, 2010 at 9:27 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Wed, 2 Jun 2010 20:04:28 +0530 Nobin Mathew wrote:
>
>> adding linux-arm-kernel@lists.infradead.org
>>
>> Hi,
>>
>> The following entry creates problem in ARM System type menu. I am
>> using a Fedora 12 system.
>
> What kind of problem does it create?
> It seems to work for me (on f11, not f12).
> Does it have something to do with F12 specifically?
>
>
>> Length of bool "Samsung S3C2410, S3C2412, S3C2413, S3C2416, S3C2440,
>> S3C2442, S3C2443, S3C2450" is the problem. How can I fix it.
>
> Describe the problem, please.
>
>> config ARCH_S3C2410
>>        bool "Samsung S3C2410, S3C2412, S3C2413, S3C2416, S3C2440,
>> S3C2442, S3C2443, S3C2450"
>>        select GENERIC_GPIO
>>        select ARCH_HAS_CPUFREQ
>>        select HAVE_CLK
>>        select ARCH_USES_GETTIMEOFFSET
>>        help
>>          Samsung S3C2410X CPU based systems, such as the Simtec Electronics
>>          BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
>>          the Samsung SMDK2410 development board (and derivatives).
>>
>>          Note, the S3C2416 and the S3C2450 are so close that they even share
>>          the same SoC ID code. This means that there is no seperate machine
>>          directory (no arch/arm/mach-s3c2450) as the S3C2416 was first.
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
