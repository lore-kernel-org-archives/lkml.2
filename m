Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1FSR3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 13:29:05 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:38590 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752351Ab1FSR3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 13:29:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBABwx/k1Ld/sX/2dsb2JhbAAMRoRJ2QSPaoErg3WBCgShew
X-IronPort-AV: E=Sophos;i="4.65,389,1304308800"; 
   d="scan'208";a="116629711"
Message-ID: <4DFE31DC.4080201@teksavvy.com>
Date: Sun, 19 Jun 2011 13:29:00 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, Wim Van Sebroeck <wim@iguana.be>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH 7/10 v2] Generic Watchdog Timer Driver
References: <20110618172537.GH3441@infomag.iguana.be>	<201106182107.45682.arnd@arndb.de>	<20110619110328.39c0f5e1@lxorguk.ukuu.org.uk>	<201106191325.17181.arnd@arndb.de> <20110619151909.1403205d@lxorguk.ukuu.org.uk>
In-Reply-To: <20110619151909.1403205d@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-06-19 10:19 AM, Alan Cox wrote:
>>> Then you'd need an additional interface to specify which watchdog as soon
>>> as we support multiple watchdogs.
>>
>> You can always have multiple ways of setting nowayout -- hardware requirements,
>> global module option, local module option, and a new ioctl command -- but
>> what is being used is then the logical OR of all of them.
> 
> An ioctl for it would make a lot of sense as watchdogs are often compiled
> in so currently there isn't a good way to runtime set this.

I wouldn't mind a kernel parameter to enable a hardware watchdog timer at boot.
Currently, there's a window at startup where the watchdog is not enabled,
and the system could lock up and die in there without it being triggered.

Cheers
