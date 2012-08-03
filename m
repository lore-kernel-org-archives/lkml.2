Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab2HCR3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:29:17 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:55322 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752787Ab2HCR3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:29:16 -0400
Message-ID: <501C0A21.2010905@xenotime.net>
Date: Fri, 03 Aug 2012 10:28:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-next@vger.kernel.org
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, AnilKumar Ch <anilkumar@ti.com>
Subject: Re: linux-next: Tree for July 17 (mfd/tps65217.c)
References: <20120717154153.b10774cb005add05e4c4e5f6@canb.auug.org.au> <5005DDA7.6050401@xenotime.net>
In-Reply-To: <5005DDA7.6050401@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 02:48 PM, Randy Dunlap wrote:

> On 07/16/2012 10:41 PM, Stephen Rothwell wrote:
> 
>> Hi all,
>>
>> Changes since 20120716:
>>
> 
> 
> on i386:
> 
> drivers/built-in.o: In function `tps65217_probe':
> tps65217.c:(.devinit.text+0x13e37): undefined reference to `of_regulator_match'
> 
> 
> Full randconfig file is attached.
> CONFIG_REGULATOR is not enabled.
> 


This build error is still present in linux-next of 20120803.


-- 
~Randy
