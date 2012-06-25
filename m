Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab2FYFGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 01:06:06 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:41697 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752813Ab2FYFGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 01:06:03 -0400
Message-ID: <4FE7F19E.9020706@xenotime.net>
Date: Sun, 24 Jun 2012 22:05:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Paul Mundt <lethal@linux-sh.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: error: implicit declarations of BUG/BUG_ON/WARN_ON/WARN_ON_ONCE
References: <20120615143303.3b88edcbc3efc7b1bf81839b@canb.auug.org.au> <20120615065231.GA12272@localhost> <4FDB6261.2030400@xenotime.net> <4FDF5D50.7030505@xenotime.net> <20120622071305.GA15102@localhost> <20120625025301.GB9317@linux-sh.org> <20120625042017.GA11705@localhost> <4FE7E7CA.2030706@xenotime.net> <20120625043836.GA11937@localhost> <4FE7EB96.4050908@xenotime.net> <20120625045513.GC11989@localhost>
In-Reply-To: <20120625045513.GC11989@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2012 09:55 PM, Fengguang Wu wrote:

> On Sun, Jun 24, 2012 at 09:39:50PM -0700, Randy Dunlap wrote:
>> On 06/24/2012 09:38 PM, Fengguang Wu wrote:
>>
>>> On Sun, Jun 24, 2012 at 09:23:38PM -0700, Randy Dunlap wrote:
>>>> On 06/24/2012 09:20 PM, Fengguang Wu wrote:
>>>>
>>>>> Hi Paul,
>>>>>
>>>>> The patch builds fine, thank you!
>>>>>
>>>>> Tested-by: Fengguang Wu <wfg@linux.intel.com>
>>>>
>>>> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
>>>>
>>>> You clearly have better build hardware than I do (a simple Core i5
>>>> laptop).  ;)
>>>
>>> Thanks, and it's a surprise that you caught so many bugs with a laptop! ;)
>>
>> Well, that "automation" stuff helps.  It runs overnight while I sleep,
>> then I report results during the day.
> 
> Kudos! I never thought of utilizing my laptop this way at night.
> Hmm, not a bad idea, especially during the code winter ;-)
> 
> Do you do auto bisections when catch any build errors?


Nope, I don't even use git trees for linux-next, just the daily
tarball.

-- 
~Randy
