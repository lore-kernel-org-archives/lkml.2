Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab0LOMrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 07:47:32 -0500
Received: from daytona.panasas.com ([67.152.220.89]:24774 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab0LOMra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 07:47:30 -0500
Message-ID: <4D08B8DF.9080503@panasas.com>
Date: Wed, 15 Dec 2010 14:47:27 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: linux-next: Tree for November 18
References: <20101118134256.fe132215.sfr@canb.auug.org.au>	<4CE54562.9030603@panasas.com>	<20101119103300.243b17c8.sfr@canb.auug.org.au>	<4CE92F96.7000002@panasas.com> <20101214135917.5b5a73e5.randy.dunlap@oracle.com>
In-Reply-To: <20101214135917.5b5a73e5.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Dec 2010 12:47:29.0427 (UTC) FILETIME=[3BC7EE30:01CB9C56]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 11:59 PM, Randy Dunlap wrote:
> On Sun, 21 Nov 2010 16:41:26 +0200 Boaz Harrosh wrote:
> 
>>
>> Meanwhile I have setup a cron job for every-night to checkout linux-next
>> and "make". As a backup for above, until it is fixed.
>>
>> Anything else I can contribute to this cause?
> 
> 
> From my small testing, it looks like ARCH=um "defconfig" is about the only
> config that comes close to building reliably.  allmodconfig/allyesconfig and
> several randconfig attempts all failed with many horrible errors.
> 
> Is that about right?
> 
> ---
> ~Randy

Hi Randy

Yes you are basically right. One must start with defconfig and add anything
he needs. UM has neglected to play it nice with Kernel, missing some basic
implementations of simple things, just for example ndelay. So some code that
should theoretically work, fails to compile.

I have around an allmodconfig with the minimum of configs turned off, so
to compile a maximum possible coverage. I have this pet project of half
Kconfig "depends on !UM" and half "implement some missing parts". But I
never have time to actually clean it up, patch it and send it upstream.

Thanks
Boaz
