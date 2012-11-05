Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab2KEOyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:54:11 -0500
Received: from exprod7og123.obsmtp.com ([64.18.2.24]:47079 "EHLO
	exprod7og123.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab2KEOyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:54:09 -0500
Message-ID: <5097D30A.1030607@genband.com>
Date: Mon, 05 Nov 2012 08:54:02 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Michal Zatloukal <myxal.mxl@gmail.com>
CC: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: Fwd: Nice processes prevent frequency increases - possible scheduler
 regression (known good in 2.6.35)
References: <CAKKZj2Do+ViFbdmeA9y4qZ4Dd_CrW_wmVWc0_CB4BAAwO6SfJg@mail.gmail.com> <CAKKZj2Av0TN9MbYk=-2ZB_jxDnUCWfrN5tJNZ7azgSHyOrMzvg@mail.gmail.com> <1351942405.16850.23.camel@maggy.simpson.net> <1351943332.16850.25.camel@maggy.simpson.net> <CAKKZj2D-jCkAbEKPX75OFYWrdSYxwh6fFBFy9UBDxy_XHHX3Gg@mail.gmail.com>
In-Reply-To: <CAKKZj2D-jCkAbEKPX75OFYWrdSYxwh6fFBFy9UBDxy_XHHX3Gg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Nov 2012 14:54:03.0646 (UTC) FILETIME=[65BB09E0:01CDBB65]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19340.007
X-TM-AS-Result: No--8.465400-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2012 09:40 AM, Michal Zatloukal wrote:
> On Sat, Nov 3, 2012 at 12:48 PM, Mike Galbraith<efault@gmx.de>  wrote:
>> On Sat, 2012-11-03 at 04:33 -0700, Mike Galbraith wrote:
>>> On Fri, 2012-11-02 at 21:09 +0100, Michal Zatloukal wrote:

>>> Your nice 19 tasks receiving 'too much' CPU when there are other
>>> runnable tasks around sounds like you have SCHED_AUTOGROUP enabled.
>>
>> (forgot to mention: if that's the case, you can add noautogroup to your
>> kernel command line to turn it off if distro turned it on in .config)
>>
>
> Thanks, Ubuntu's kernel is indeed configured with that option enabled,
> and passing "noautogroup" at grub restores the previous behaviour. I'm
> back to happy days again :) BTW, isn't this the "magic 200-line patch"
> I was reading about ~2 years ago?

Yes.

Chris
