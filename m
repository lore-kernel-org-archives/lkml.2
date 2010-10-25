Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab0JYHFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 03:05:46 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:45228 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab0JYHFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 03:05:45 -0400
X-Auth-Info: Q090/e2zJcrXBUJIv3IRHXAzbubn4+K0lMRJIBZXjAA=
Message-ID: <4CC52C86.1050205@grandegger.com>
Date: Mon, 25 Oct 2010 09:06:46 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: David Miller <davem@davemloft.net>, andrew.chih.howe.khor@intel.com,
        socketcan-core@lists.berlios.de, sameo@linux.intel.com,
        margie.foster@intel.com, netdev@vger.kernel.org, chripell@fsfe.org,
        linux-kernel@vger.kernel.org, yong.y.wang@intel.com,
        masa-korg@dsn.okisemi.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com, morinaga526@dsn.okisemi.com, qi.wang@intel.com
Subject: Re: [PATCH net-next-2.6 v1] can: Topcliff: Update PCH_CAN driver
 to 2.6.35
References: <4CB8506C.3060600@dsn.okisemi.com>	<20101024.144312.104048720.davem@davemloft.net>	<4CC4ADA5.8@pengutronix.de> <20101024.150905.39179588.davem@davemloft.net> <4CC4AFF9.90009@pengutronix.de>
In-Reply-To: <4CC4AFF9.90009@pengutronix.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2010 12:15 AM, Marc Kleine-Budde wrote:
> On 10/25/2010 12:09 AM, David Miller wrote:
>> From: Marc Kleine-Budde <mkl@pengutronix.de>
>> Date: Mon, 25 Oct 2010 00:05:25 +0200
>>
>>> On 10/24/2010 11:43 PM, David Miller wrote:
>>>> From: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
>>>> Date: Fri, 15 Oct 2010 22:00:28 +0900
>>>>
>>>>> CAN driver of Topcliff PCH
>>>>>
>>>>> Topcliff PCH is the platform controller hub that is going to be used in
>>>>> Intel's upcoming general embedded platform. All IO peripherals in
>>>>> Topcliff PCH are actually devices sitting on AMBA bus. 
>>>>> Topcliff PCH has CAN I/F. This driver enables CAN function.
>>>>>
>>>>> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
>>>>
>>>> Applied, thanks.
>>>
>>> IMHO this driver needs some improvements. There are some open points
>>> from Wolfgangs and my review. On the other side, it's a new driver and
>>> there's some time left before it hits mainline.
>>
>> When people have more than a week to review and provide feedback,
>> and don't, I have zero sympathy especially this early in the
>> release cycle.
> 
> Let me see....Crap, it's my fault, I just replied to the socketcan
> mailinglist ;( [1]
> 
>> So if adding it to the tree is what I have to do to get you guys to
>> post your comments and suggest fixes, then that's what I am going to
>> (continue) to do. :-)
> 
> ...or to learn how to reply properly :)

Ah, oh, and I added my review to yours :-(. Sorry, for the inconvenience
it caused:

https://lists.berlios.de/pipermail/socketcan-core/2010-October/004787.html

Anyway, Ohtake should have received the review. The driver is *not* yet
ready for inclusion. Therefore, please fix the remaining issues asap.

Thanks,

Wolfgang.
