Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935270Ab2KAUSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:18:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56502 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab2KAUS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:18:29 -0400
Message-ID: <5092D90F.7020105@vlnb.net>
Date: Thu, 01 Nov 2012 16:18:23 -0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?B?5p2o6IuP56uLIFlhbmcgU3UgTGk=?= <suli@cs.wisc.edu>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>	<m2fw5mtffg.fsf_-_@firstfloor.org>	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>	<5086F5A7.9090406@vlnb.net>	<20121025051445.GA9860@thunk.org>	<508B3EED.2080003@vlnb.net>	<20121027044456.GA2764@thunk.org>	<5090532D.4050902@vlnb.net> <20121031095404.0ac18a4b@pyramind.ukuu.org.uk>
In-Reply-To: <20121031095404.0ac18a4b@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:hmlVbSsT5+199tDpDKZDR/9pEBTknF5zaHhk6tzyWSE
 UEN2L9f0Jk4kC9K9z7Kz6+1D4LsiaTjFGmhE9omeOm0zrwvXOI
 KV+aIV8J4fOsxJQ/3zJ7u5Pbx7pI0/zIasgB8q0plPnHZ9s9vp
 5jJfspXT6rvj3UjMoDu6Yykf21/R9XT7/25wLcrwuzbUCcvRES
 z1ENkIVuYAKX+/Nh5sIN/7u22TFdtqkRkNHyVP3PC9GHsKqV3c
 eHC1KsrTw2+kXrlGIVhj2mt1A5FLZlRt+owzldtmgm1MN2uTtO
 OQ7af7PkbhsGRue18dsRUF3vRWU/VNzjXRH1hUFDDm9bELJJwX
 TVZHkoBzgPi44am5r1wg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alan Cox, on 10/31/2012 05:54 AM wrote:
>> I don't want to flame on this topic, but you are not right here. As far as I can
>> see, a big chunk of Linux storage and file system developers are/were employed by
>> the "gold-plated storage" manufacturers, starting from FusionIO, SGI and Oracle.
>>
>> You know, RedHat from recent times also stepped to this market, at least I saw
>> their advertisement on SDC 2012. So, you can add here all RedHat employees.
>
> Booleans generally should be reserved for logic operators. Most of the
> Linux companies work on both low and high end storage. The two are not
> mutually exclusive nor do they divide neatly by market. Many big clouds
> use cheap low end drives by the crate, some high end desktops are using
> SAS although given you can get six 2.5" hotplug drives in a 5.25" bay I'm
> not sure personally there is much point

Those doesn't contradict the point that high performance storage vendors are also 
funding Linux kernel storage development.

> Send patches with benchmarks demonstrating it is useful. It's really
> quite simple. Code talks.

How about that recently preliminary infrastructure to send ORDERED commands 
instead of queue draining was deleted from the kernel, because "there's no 
difference where to drain the queue, on the kernel or the storage side"?

Vlad
