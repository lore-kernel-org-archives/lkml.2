Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab1JDOdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 10:33:25 -0400
Received: from exprod7og105.obsmtp.com ([64.18.2.163]:38152 "EHLO
	exprod7og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab1JDOdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 10:33:24 -0400
Message-ID: <4E8B18DF.8010000@genband.com>
Date: Tue, 04 Oct 2011 08:31:59 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: David Miller <davem@davemloft.net>, johnmusbach1@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: Handling of multiple DHCP OFFERs
References: <loom.20111004T011704-753@post.gmane.org> <20111003.192129.745977451712127515.davem@davemloft.net> <4E8A46E9.2070509@genband.com> <4E8A5D74.7000507@gmail.com>
In-Reply-To: <4E8A5D74.7000507@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Oct 2011 14:32:00.0717 (UTC) FILETIME=[60CB97D0:01CC82A2]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18424.006
X-TM-AS-Result: No--6.563100-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2011 07:12 PM, Robert Hancock wrote:
> On 10/03/2011 05:36 PM, Chris Friesen wrote:
>> On 10/03/2011 05:21 PM, David Miller wrote:

>>> There are multiple userspace implementations of DHCP, and the kernel
>>> does not usually get involved at all. You'll therefore have to ask
>>> the folks who write and maintain the various DHCP implementations.
>>
>> What about netbooting? Or are you expecting people to use initramfs with
>> a userspace implementation?
>
> Normally with PXE boot it's the PXE ROM that initially gets the IP
> address. After the kernel boots up, userspace normally repeats the process.

I've worked with quite a few boards where PXE boots the kernel, but the 
kernel needs to do DHCP to get the location of the root filesystem (as 
well as various DHCP options not understood by PXE).

Chris




-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
