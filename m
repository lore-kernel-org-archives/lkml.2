Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab1AYWQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:16:43 -0500
Received: from 64.mail-out.ovh.net ([91.121.185.65]:60434 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752735Ab1AYWQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:16:42 -0500
Message-ID: <4D3F4BC5.5010507@example.com>
Date: Tue, 25 Jan 2011 23:16:37 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kurt.van.dijck@eia.be
Subject: Re: Something is wrong in your source, David
References: <4D3F4277.20008@example.com> <20110125.134455.115939217.davem@davemloft.net> <4D3F47F8.2020007@example.com>
In-Reply-To: <4D3F47F8.2020007@example.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 5460051599362388338
X-Ovh-Remote: 83.24.77.83 (dmv83.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.01.2011 23:00, Piotr Hosowicz wrote:
> On 25.01.2011 22:44, David Miller wrote:
>> From: Piotr Hosowicz<piotr@hosowicz.com>
>> Date: Tue, 25 Jan 2011 22:36:55 +0100
>>
>>> Hello David, hello all,
>>>
>>> David, when I apply your source from GIT to Linus source I get this in
>>> final part of the build process:
>>
>> Please always CC: the appropriate developer list for the subsystem
>> where you see the problem, and also make an effort to also contact the
>> developer who might be responsible for the sources in question.
>>
>> I've done this for you.
>
> Aha, OK. Sorry for the inconvenience. I attach the config which
> successfuly gets build.

Aha, now it built OK, I disabled CAN driver.

Regards,

Piotr Hosowicz

-- 
F±farowie wracaj± pieszo do domu z opery.
W pewnej chwili ¿ona mówi do mê¿a:
- Taki wstyd! Jak mog³e¶ krzykn±æ: Brawo! Bis!,
gdy primadonna wpad³a do kana³u dla orkiestry?!
NP: Peter Green Splinter Group - Big Change Is Gonna Come
NB: 2.6.38-rc2-20110125-2155-pztidm+
