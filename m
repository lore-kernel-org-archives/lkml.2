Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab1CDJve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 04:51:34 -0500
Received: from proxy.DResearch.DE ([87.193.137.100]:39189 "EHLO
	mail.dresearch.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751914Ab1CDJvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 04:51:33 -0500
Message-ID: <4D70B621.7020307@dresearch.de>
Date: Fri, 04 Mar 2011 10:51:29 +0100
From: Steffen Sledz <sledz@dresearch.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.14) Gecko/20110221 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, m.schuknecht@dresearch.de
Subject: Re: [PATCH resent] tcp: ioctl type SIOCOUTQNSD returns amount of
 data not sent
References: <1299228497-21246-1-git-send-email-sledz@dresearch.de> <20110304.010428.71127798.davem@davemloft.net>
In-Reply-To: <20110304.010428.71127798.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 04 Mar 2011 09:51:30.0008 (UTC) FILETIME=[BC82B580:01CBDA51]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.03.2011 10:04, schrieb David Miller:
> From: Steffen Sledz <sledz@dresearch.de>
> Date: Fri,  4 Mar 2011 09:48:17 +0100
> 
>> diff --git a/include/asm-generic/ioctls.h b/include/asm-generic/ioctls.h
>> index 199975f..ef2be0b 100644
>> --- a/include/asm-generic/ioctls.h
>> +++ b/include/asm-generic/ioctls.h
>> @@ -74,6 +74,7 @@
>>  #define TCSETXW		0x5435
>>  #define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
>>  #define TIOCVHANGUP	0x5437
>> +#define TIOCOUTQNSD	0x5438
>>  
>>  #define FIONCLEX	0x5450
>>  #define FIOCLEX		0x5451
> 
> Hitting only asm-generic/ioctls.h is insufficient, many architectures do
> not make use of this file and the build will fail for them with your patch
> applied.

That's not fully clear to me.

We made the define similar to the existing TIOCOUTQ. What other files should be hit?

Steffen Sledz

-- 
DResearch Fahrzeugelektronik GmbH
Otto-Schmirgal-Str. 3, 10319 Berlin, Germany
Tel: +49 30 515932-237 mailto:sledz@DResearch.de
Fax: +49 30 515932-299
Geschäftsführer: Dr. Michael Weber, Werner Mögle;
Amtsgericht Berlin Charlottenburg; HRB 130120 B;
Ust.-IDNr. DE273952058

