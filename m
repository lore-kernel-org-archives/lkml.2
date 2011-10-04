Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab1JDBMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 21:12:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38804 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab1JDBMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 21:12:23 -0400
Message-ID: <4E8A5D74.7000507@gmail.com>
Date: Mon, 03 Oct 2011 19:12:20 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Chris Friesen <chris.friesen@genband.com>
CC: David Miller <davem@davemloft.net>, johnmusbach1@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: Handling of multiple DHCP OFFERs
References: <loom.20111004T011704-753@post.gmane.org> <20111003.192129.745977451712127515.davem@davemloft.net> <4E8A46E9.2070509@genband.com>
In-Reply-To: <4E8A46E9.2070509@genband.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2011 05:36 PM, Chris Friesen wrote:
> On 10/03/2011 05:21 PM, David Miller wrote:
>> From: John Musbach<johnmusbach1@gmail.com>
>> Date: Mon, 3 Oct 2011 23:18:06 +0000 (UTC)
>>
>>> Hello, I am configuring a network that'll have multiple DHCP servers
>>> and I was wondering how Linux handles receiving multiple DHCP OFFERs?
>>> More specifically, how does it choose which one to prefer and how long
>>> will it wait for a answer from a preferred server if the other server
>>> answers first? Thanks.
>>
>> There are multiple userspace implementations of DHCP, and the kernel
>> does not usually get involved at all. You'll therefore have to ask
>> the folks who write and maintain the various DHCP implementations.
>
> What about netbooting? Or are you expecting people to use initramfs with
> a userspace implementation?
>
> Chris
>

Normally with PXE boot it's the PXE ROM that initially gets the IP 
address. After the kernel boots up, userspace normally repeats the process.
