Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2AWTMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:12:48 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43998 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab2AWTMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:12:47 -0500
Message-ID: <4F1DB12A.7010001@vflare.org>
Date: Mon, 23 Jan 2012 14:12:42 -0500
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
CC: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
        Richard Purdie <rpurdie@openedhand.com>
Subject: Re: ANN: linux-kernel-lzo-2.06.20120123 - update LZO to v2.06
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org> <4F16DFB0.2060404@oberhumer.com> <4F1D889C.2050706@oberhumer.com>
In-Reply-To: <4F1D889C.2050706@oberhumer.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

Thanks for the patches!

On 01/23/2012 11:19 AM, Markus F.X.J. Oberhumer wrote:

> Hi,
> 
> I've prepared a small package that updates the LZO version in the Linux
> kernel to LZO v2.06.
> 
> Please get it from:
> 
>   http://www.oberhumer.com/opensource/lzo/download/Testing/linux-kernel-lzo-2.06.20120123.tar.gz
> 
> As stated in the README, its main purpose is to allow easy benchmarking of the
> latest LZO versions - these do feature some nice speed improvements, and while
> I have done a lot of synthetic benchmarking I'm really very curious and
> appreciate feedback on "real-world" performance numbers like usage in
> btrfs and zram.
> 

I will soon integrate them with zram and get some performance numbers.

Thanks,
Nitin



> 
> http://www.oberhumer.com/opensource/lzo/
> 
> On 2012-01-18 16:05, Markus F.X.J. Oberhumer wrote:
>> On 2012-01-13 01:28, Andi Kleen wrote:
>>> Here's a slightly updated version of the BTRFS snappy interface.
>>> snappy is a faster compression algorithm that provides similar
>>> compression as LZO, but generally better performance.
>>
>> I'd like to note that the LZO version in the current Linux kernel is
>> rather outdated - it seems to be based on the 2005 release.
>>
>> In fact the latest version LZO 2.06 does compress both slightly faster and
>> better than snappy 1.0.4 when benchmarking the Calgary and Silesia
>> compression corpus (tested with gcc 4.6 on Nehalem & Sandy Bridge).
>>
>> Furthermore please be aware that from a pure compression point of view
>> snappy et al. are very close cousins of LZO (strictly byte-aligned LZ77)
>> that mainly differ in implementation issues like using a table to
>> number of branches - and indeed similar optimizations could be applied
>> to any version.
>>
>> I'm not sure if there is an official kernel maintainer of LZO, but I'd
>> offer to assist you updating to the latest version and eliminating
>> any possible performance issues.
> 


