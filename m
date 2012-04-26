Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab2DZKHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 06:07:48 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:26825 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab2DZKHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 06:07:47 -0400
Message-ID: <4F991E6D.4020303@atmel.com>
Date: Thu, 26 Apr 2012 12:07:41 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <avictor.za@gmail.com>,
        <plagnioj@jcrosoft.com>
Subject: Re: [GIT PULL] net/at91: at91_ether fixes for 3.4-rc
References: <4F991210.8060409@atmel.com> <20120426.052006.1832921763623188173.davem@davemloft.net>
In-Reply-To: <20120426.052006.1832921763623188173.davem@davemloft.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.159.245.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 11:20 AM, David Miller :
> From: Nicolas Ferre <nicolas.ferre@atmel.com>
> Date: Thu, 26 Apr 2012 11:14:56 +0200
> 
>> Can you please pull those fixes for 3.4-rc? The ARM/AT91 part
>> of modifications is pretty small and bounded to a single SoC so
>> it will not mess with arm-soc git tree.
> 
> Please post the patches themselves to netdev.
> 
> You can give me pull requests, but those go into the "[PATCH 0/N] ..."
> email, it doesn't preclude you're still having to post the actual
> patches.
> 
> Otherwise nobody can review your work.

Both patches have been posted on netdev (but independently):

First has been posted on February 13th:
http://www.spinics.net/lists/netdev/msg188868.html
With a question from myself a few days ago:
http://www.spinics.net/lists/netdev/msg196183.html
And I can find ancestors back in May 2011...

Second one has been posted on April 23rd:
http://www.spinics.net/lists/netdev/msg196002.html

So, should I repost both of them as patch series?

Best regards,
-- 
Nicolas Ferre
