Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab2BOWBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:01:52 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:35691 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755071Ab2BOWBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:01:50 -0500
Message-ID: <4F3C2B28.7030802@xenotime.net>
Date: Wed, 15 Feb 2012 14:01:12 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: linux-next: Tree for Feb 15 (decnet)
References: <20120215160352.60be31b78879628be7e446b8@canb.auug.org.au>	<4F3C0CE3.6020708@xenotime.net> <20120215.163801.2243433584488421039.davem@davemloft.net>
In-Reply-To: <20120215.163801.2243433584488421039.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2012 01:38 PM, David Miller wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> Date: Wed, 15 Feb 2012 11:52:03 -0800
> 
>> On 02/14/2012 09:03 PM, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20120214:
>>
>>
>> on x86_64:
>>
>>   CC      net/decnet/dn_nsp_in.o
>> In file included from /next/linux-next-20120215/net/decnet/dn_nsp_in.c:75:0:
>> /next/linux-next-20120215/include/net/dn.h:195:65: warning: 'struct flowidn' declared inside parameter list
> 
> I can't reproduce this in the net-next tree using your config but I can
> certainly fix it, as follows :-)

Yes, you fixed it.  Thanks.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>


> --------------------
> decnet: net/dn.h needs net/flow.h
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  include/net/dn.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/dn.h b/include/net/dn.h
> index 298521e..814af0b 100644
> --- a/include/net/dn.h
> +++ b/include/net/dn.h
> @@ -3,6 +3,7 @@
>  
>  #include <linux/dn.h>
>  #include <net/sock.h>
> +#include <net/flow.h>
>  #include <asm/byteorder.h>
>  #include <asm/unaligned.h>
>  


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
