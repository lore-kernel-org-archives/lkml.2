Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab1ITUNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 16:13:24 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:3169 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114Ab1ITUNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 16:13:22 -0400
Message-ID: <4E78F47B.7000906@hetnet.nl>
Date: Tue, 20 Sep 2011 22:15:55 +0200
From: Henk de Groot <henk.de.groot@hetnet.nl>
Reply-To: henk.de.groot@hetnet.nl
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Dave Kilroy <kilroyd@googlemail.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, pe1dnn@amsat.org
Subject: Re: [PATCH 3/3] staging: wlags49_h2: Declare support for WEXT 21
References: <1316462896-17846-1-git-send-email-kilroyd@googlemail.com> <1316462896-17846-4-git-send-email-kilroyd@googlemail.com> <15411.1316463771@turing-police.cc.vt.edu> <4E77A9B1.1040107@gmail.com> <20110920195205.GA27739@kroah.com>
In-Reply-To: <20110920195205.GA27739@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Sep 2011 20:13:17.0155 (UTC) FILETIME=[BBEB9330:01CC77D1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

Op 20-9-2011 21:52, Greg KH schreef:
> I've applied the first 2 of these, if you want me to apply the third
> one, please resend it after it's been tested by someone.
>
> thanks,
>
> greg k-h
>

I have the patched driver running on the 2.6.38-11-generic #48 Ubuntu 
11.04 Natty Narwhal kernel, which, as far as I could determine, uses WEXT 
version 22. The patch didn't improve anything other than the code itself, 
but didn't break anything either. Tested with WEP accesspoint, WPA still 
not functional. The still appears to be stable.

Henk.

