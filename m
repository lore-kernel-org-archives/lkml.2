Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941Ab2CNDJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 23:09:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33129 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab2CNDJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 23:09:43 -0400
Message-ID: <4F600BF3.2080001@lwfinger.net>
Date: Tue, 13 Mar 2012 22:09:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Miller <amiller@amilx.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8187se: r8180_core.c: Fix coding style issue
References: <1331686689-6763-1-git-send-email-amiller@amilx.com>  <1331688836.27389.13.camel@joe2Laptop> <20120314014949.GB7156@iron>  <1331691146.27389.20.camel@joe2Laptop> <20120314023342.GC7156@iron> <1331693187.27389.33.camel@joe2Laptop>
In-Reply-To: <1331693187.27389.33.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 09:46 PM, Joe Perches wrote:
> On Tue, 2012-03-13 at 22:33 -0400, Andrew Miller wrote:
>> Thanks, you help me alot
>>
>> If you don't mind me asking a few more question.
>>
>> Would fixing things like this
>>
>> - if(x==y)
>> + if(x == y)
>>
>> be worthless?
>
> I don't work on staging code.
>
> I believe the staging rtl8187se directory could be
> deleted as there is a working mainline directory
> for the 8187 (drivers/net/wireless/rtl818x/rtl8187)
> so you may not actually be adding anything of value.
>
> I don't know if the 8187se is supported by the 8187
> code but likely Larry Finger (cc'd) knows better.

Driver rtl8187 handles USB devices - the RTL8187SE is PCI based - thus separate 
drivers are needed. I have done a lot of the conversion of a mac80211-based 
driver for the RTL8187SE, but ran into a problem where it could transmit small 
packets, but fail completely for longer ones. While trying to fix that, I needed 
to work on devices that had no Linux driver, and I have not gotten back to it.

Larry

