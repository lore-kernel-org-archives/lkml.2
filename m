Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965348Ab1GMLWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 07:22:30 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2703 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964915Ab1GMLW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 07:22:27 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4E1D7FCA.1050203@broadcom.com>
Date: Wed, 13 Jul 2011 13:21:46 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: "David Miller" <davem@davemloft.net>
cc: "adobriyan@gmail.com" <adobriyan@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: change return values in mac_pton() function
References: <1310549424-5484-1-git-send-email-arend@broadcom.com>
 <CACVxJT-TXBd5S+HNfzNR2hnGUk2hMfTSQrkodUunUXOQ6+X8eg@mail.gmail.com>
 <20110713.041253.1879038886370324446.davem@davemloft.net>
In-Reply-To: <20110713.041253.1879038886370324446.davem@davemloft.net>
X-WSS-ID: 62035E8E3B419675149-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2011 01:12 PM, David Miller wrote:
> From: Alexey Dobriyan<adobriyan@gmail.com>
> Date: Wed, 13 Jul 2011 13:09:03 +0300
>
>> On Wed, Jul 13, 2011 at 12:30 PM, Arend van Spriel<arend@broadcom.com>  wrote:
>>> The original commit adding this function noted a diverge from usual
>>> 0=success/-E=fail, but no motivation for it.
>> I thought it was obvious, but indeed wasn't explicitely
>> mentioned in changelog. But see inet_pton(3).
> Agreed it's better for mac_pton() to be consistent with existing,
> similar, interfaces like inet_pton.

I just liked the general approach of zero indicating success. But even 
in the realm called Linux not everything can be black and white, I guess :-D

Please drop the patch.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


