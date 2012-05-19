Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2ESP6E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 11:58:04 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:35307 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750806Ab2ESP6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 11:58:02 -0400
Message-ID: <4FB7C310.3010403@xenotime.net>
Date: Sat, 19 May 2012 08:58:08 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Mike Rapoport <mike@compulab.co.il>
Subject: Re: linux-next: Tree for May 16 (mfd/tpx6586x)
References: <20120516201426.3a162ecd6adeb7132413f1b9@canb.auug.org.au> <4FB3D2C3.3030507@xenotime.net> <20120519142506.GN12015@sortiz-mobl>
In-Reply-To: <20120519142506.GN12015@sortiz-mobl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2012 07:25 AM, Samuel Ortiz wrote:

> Hi Randy,
> 
> On Wed, May 16, 2012 at 09:16:03AM -0700, Randy Dunlap wrote:
>> On 05/16/2012 03:14 AM, Stephen Rothwell wrote:
>>
>>>
>>> The mfd tree lost its build failure but gained another so I used the
>>> version from next-20120511.
>>>
>>
>>
>>
>> (on i386)
>>
>> drivers/built-in.o: In function `tps6586x_i2c_probe':
>> tps6586x.c:(.devinit.text+0x144e0): undefined reference to `of_regulator_match'
>>
> Is this one fixed now ? It's coming from Mark's regulator tree, not the MFD
> one.


It still fails in linux-next of 20120518.

> Mark, I think mfd/tps6586x.c should select REGULATOR to avoid this one.
> 
> Cheers,
> Samuel.
> 
> 
>> Full randconfig file is attached.
>>
>> -- 
>> ~Randy


-- 
~Randy
