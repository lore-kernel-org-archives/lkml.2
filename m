Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab0HYKLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 06:11:45 -0400
Received: from t03.superonline.com ([92.45.6.166]:40335 "EHLO
	smtpout2.superonline.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753035Ab0HYKLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 06:11:44 -0400
Message-ID: <4C74EC50.30201@superonline.com>
Date: Wed, 25 Aug 2010 13:11:28 +0300
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100821 Icedove/3.1.2
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernationto hang
References: <20100820115449.5FF1.A69D9226@jp.fujitsu.com> <4C715027.9060602@superonline.com> <20100825175034.F3EA.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100825175034.F3EA.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SMTP-Filter: SurGATE SMTP Filter Engine Release 2.1 ($Revision: 184 $) http://www.endersys.com
X-SurGATE-Result: Clean (Content eval: 2.00 points)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/08/10 11:55 AM, KOSAKI Motohiro wrote:
>>> % cat /proc/meminfo
>>
>> MemTotal:        3104484 kB
>> MemFree:         2817616 kB
>> Buffers:           31156 kB
>> Cached:           142124 kB
>> SwapCached:            0 kB
>> Active:           116464 kB
>> Inactive:         137424 kB
>> Active(anon):      80852 kB
>> Inactive(anon):    24820 kB
>> Active(file):      35612 kB
>> Inactive(file):   112604 kB
>> Unevictable:          32 kB
>> Mlocked:              32 kB
>> HighTotal:       2226632 kB
>> HighFree:        1994008 kB
>> LowTotal:         877852 kB
>> LowFree:          823608 kB
>> SwapTotal:       1999540 kB
>> SwapFree:        1999540 kB
> 
> !! Your swap partition is smaller than physical memory. As far as I know,
> swap partition need physcal-mem x 2 size. Can you please try to change 
> swap configuration?
> 
> Rafael, please correct me if I'm talking wrong.
> 
> Thanks.

[Please see my reply in the other thread.]


