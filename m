Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423809Ab2LFPPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:15:13 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:56035 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423776Ab2LFPPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:15:10 -0500
Message-ID: <50C0B694.60408@erwinrol.com>
Date: Thu, 06 Dec 2012 16:15:32 +0100
From: Erwin Rol <mailinglists@erwinrol.com>
Organization: Erwin Rol Software Engineering
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: linux-kernel@vger.kernel.org, Havard Skinnemoen <havard@skinnemoen.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        matteo.fortini@sadel.it, netdev <netdev@vger.kernel.org>
Subject: Re: at91sam9260 MACB problem with IP fragmentation
References: <50C08233.9030905@erwinrol.com> <50C09D2E.8050608@atmel.com>
In-Reply-To: <50C09D2E.8050608@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Dec 2012 15:15:03.0936 (UTC) FILETIME=[77BA4800:01CDD3C4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Nicolas,

On 6-12-2012 14:27, Nicolas Ferre wrote:
> Erwin,
> 
> On 12/06/2012 12:32 PM, Erwin Rol :
>> Hello Nicolas, Havard, all,
>>
>> I have a very obscure problem with a at91sam9260 board (almost 1 to 1
>> copy of the Atmel EK).
>>
>>  <snip>
>>
> [..]
> 
> It seems that Matteo has the same behavior: check here:
> http://www.spinics.net/lists/netdev/msg218951.html

The difference seems to be that in Matteo's case the receiving stalls.
In my case it is the sending that stalls. I see the UDP datagram in
userspace and the sendto call also returns without error, but the data
does not end up on the network (until the next packet is send)

> I am working on the macb driver right now, so I will try to reproduce
> and track this issue on my side.

That would be really great, and thank you for the quick reply. If you
have anything that I should try or test on my hardware just let me know.

BTW: A quick check on a at91sam9263 board did not show the problem. I
will try to verify if it really does work on a 9263, cause maybe it just
more rare on a 9263.

- Erwin

