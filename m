Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab1GGOtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:49:25 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:35952 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab1GGOtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:49:20 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E15C94D.9080205@cam.ac.uk>
Date: Thu, 07 Jul 2011 15:57:17 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: Christoph Lameter <cl@linux.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Build issue with linux next. duplicate member _count in mm_types.h
References: <4E143120.2020501@cam.ac.uk> <alpine.DEB.2.00.1107060933460.17202@router.home> <4E15AF1C.7080103@example.com> <alpine.DEB.2.00.1107070841500.17376@router.home> <4E15B945.5060805@example.com> <alpine.DEB.2.00.1107070908320.17929@router.home> <4E15C59E.5000900@example.com>
In-Reply-To: <4E15C59E.5000900@example.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/11 15:41, Piotr Hosowicz wrote:
> On 07.07.2011 16:09, Christoph Lameter wrote:
>> On Thu, 7 Jul 2011, Piotr Hosowicz wrote:
>>
>>> I attach it. Your patch seems to had worked, I finish making the package.
>>
>> I do not see anything remarkable in the config file.
>>
>> Which compiler version are you using?
>>
>> Mine is:
>>
>> christoph@oldy:~$ gcc --version
>> gcc (Ubuntu/Linaro 4.4.4-14ubuntu5) 4.4.5
>> Copyright (C) 2010 Free Software Foundation, Inc.
>> This is free software; see the source for copying conditions. There is NO
>> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
>> PURPOSE.
> 
> Mine is:
> 
> aapi205:~# gcc --version
> gcc (Debian 4.6.0-10) 4.6.1 20110526 (prerelease)
> Copyright (C) 2011 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
Mine, 

gcc version 4.6.1 20110617 (prerelease) (GCC) 

