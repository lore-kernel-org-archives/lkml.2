Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2HAOGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:06:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43866 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab2HAOGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:06:52 -0400
Message-ID: <501937F7.2070600@landley.net>
Date: Wed, 01 Aug 2012 09:06:47 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Milton Miller <miltonm@bga.com>
CC: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        Borislav Petkov <bp@alien8.de>, Cong Wang <xiyou.wangcong@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] netconsole.txt: "nc" needs "-p" to specify the listening
 port
References: <gilii4nnxb.fsf@mx10.gouders.net> <kernel-nc-hints@mdm.bga.com>
In-Reply-To: <kernel-nc-hints@mdm.bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2012 03:40 AM, Milton Miller wrote:
> [adding Rob as Doc maintanier]
> 
> On Sat, 28 Jul 2012 about 11:08:16 -0000, Dirk Gouders wrote:
>> Borislav Petkov <bp@alien8.de> writes:
>>
>>> On Fri, Jul 27, 2012 at 11:24:53AM +0200, Dirk Gouders wrote:
>>>> Cong Wang <xiyou.wangcong@gmail.com> writes:
>>>>
>>>>> On Fri, Jul 27, 2012 at 2:35 PM, Dirk Gouders
>>>>> <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
>>>>>> Hi Jesse,
>>>>>>
>>>>>> I would like to ask you to check if the documentation of "nc" in
>>>>>> netconsole.txt is still correct.  I tried two different netcat packages
>>>>>> and both require "-p" to specify the listening port.  I am wondering if
>>>>>> that changed after the use of "nc" has been documented.
>>>>>
>>>>> On Fedora 16, `nc -u -l <port number>` works fine.
>>>>
>>>> Thanks for checking that.
>>>>
>>>> If the information I found is correct, Fedora uses OpenBSD's nc
>>>> codebase.  The two netcat packages I tested on a Gentoo system differ in
>>>> requiring the -p switch for the port specification.
>>>
>>> So say exactly that in the doc: that the *BSD's version of nc doesn't
>>> need the port number specified with '-p' and you're covered.
>> OK, I tried that in the attached patch.
>> I'm not sure if every exeption needs to/should be documented, though.
>>
>> >From 3cdeac3e814471053129145c5fa8391acb365fd8 Mon Sep 17 00:00:00 2001
>> From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
>> Date: Sat, 28 Jul 2012 12:32:49 +0200
>> Subject: [PATCH] netconsole.txt: non-BSD versions of nc(1) require '-p'
>>  switch
>>
>> Gentoo for example uses non-BSD versions of nc(1) which require
>> the '-p' switch to specify the listening port.
>>
>> ---
>> Documentation/networking/netconsole.txt |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)

Did this ever resolve to a specific recommended patch? The one at the
start of the thread:

 http://lkml.indiana.edu/hypermail/linux/kernel/1207.3/01995.html

Apparently isn't it...?

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
