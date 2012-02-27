Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab2B0Ist (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 03:48:49 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37895 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab2B0Iss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 03:48:48 -0500
Message-ID: <4F4B436A.4050702@suse.cz>
Date: Mon, 27 Feb 2012 09:48:42 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120222 Thunderbird/11.0
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Holger Macht <holger@homac.de>, Jiri Slaby <jirislaby@gmail.com>,
        Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ahci: sata hotplug doesn't work after suspend
References: <4F415775.7060003@suse.cz> <20120219211709.GA30809@homac.suse.de> <1329726646.3368.2.camel@minggr> <4F42420E.2010301@suse.cz> <1329964013.18070.3.camel@minggr> <CAF1ivSaQU1MXbExbtRkXy5YcbymCM_9DdR9d4BqMbti2rbvehg@mail.gmail.com>
In-Reply-To: <CAF1ivSaQU1MXbExbtRkXy5YcbymCM_9DdR9d4BqMbti2rbvehg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2012 02:05 AM, Lin Ming wrote:
>> Could you please try below patch?
>>
>> And please also show the debug info.
>> dmesg |grep "DEBUG: port"
>
> Hi Jiri,
>
> Will you get a chance to test this patch?

Yes, yesterday I booted a kernel with that patch, today I resumed from 
suspend. It works fine.

[    3.544423] DEBUG: port 0, PORT_CMD=0x40006
[    3.544445] DEBUG: port 1, PORT_CMD=0x40006
[    3.544467] DEBUG: port 2, PORT_CMD=0x40006
[    3.544489] DEBUG: port 3, PORT_CMD=0x40006
[    3.544511] DEBUG: port 4, PORT_CMD=0x6
[    3.544532] DEBUG: port 5, PORT_CMD=0x6
[ 1724.132173] DEBUG: port 0, PORT_CMD=0x40006
[ 1724.132184] DEBUG: port 1, PORT_CMD=0x40006
[ 1724.132194] DEBUG: port 2, PORT_CMD=0x40006
[ 1724.132204] DEBUG: port 3, PORT_CMD=0x40006
[ 1724.132214] DEBUG: port 4, PORT_CMD=0x6
[ 1724.132222] DEBUG: port 5, PORT_CMD=0x6

thanks,
-- 
js
suse labs
