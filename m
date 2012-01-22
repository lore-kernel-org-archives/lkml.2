Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab2AVTVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 14:21:38 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:48925 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2AVTVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 14:21:37 -0500
Date: Sun, 22 Jan 2012 14:21:29 -0500 (EST)
Message-Id: <20120122.142129.1690845179274032982.davem@davemloft.net>
To: joe@perches.com
Cc: standby24x7@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH/RESEND] [trivial] sctp : Fix typo in net/sctp/socket.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1327109035.1921.1.camel@joe2Laptop>
References: <1327108681-1682-1-git-send-email-standby24x7@gmail.com>
	<1327109035.1921.1.camel@joe2Laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 22 Jan 2012 11:21:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 20 Jan 2012 17:23:55 -0800

> On Sat, 2012-01-21 at 10:18 +0900, Masanari Iida wrote:
>> Signed-off-by: Masanari Iida<standby24x7@gmail.com>
>> 
>> Correct a typo "sctp_setsocktopt_bindx" to "sctp_setsockopt_bindx"
>> in net/sctp/socket.c
>> ---
>>  net/sctp/socket.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
>> index 408ebd0..658483e 100644
>> --- a/net/sctp/socket.c
>> +++ b/net/sctp/socket.c
>> @@ -970,7 +970,7 @@ SCTP_STATIC int sctp_setsockopt_bindx(struct sock* sk,
>>  	void *addr_buf;
>>  	struct sctp_af *af;
>>  
>> -	SCTP_DEBUG_PRINTK("sctp_setsocktopt_bindx: sk %p addrs %p"
>> +	SCTP_DEBUG_PRINTK("sctp_setsockopt_bindx: sk %p addrs %p"
>>  			  " addrs_size %d opt %d\n", sk, addrs, addrs_size, op);
> 
> Let the compiler do it.
> 
> 	SCTP_DEBUG_PRINTK("%s: sk %p addrs %p addrs_size %d opt %d\n",
> 			  __func__, sk, addrs, addrs_size, op);

Masanari, please integrate Joe's feedback into your patch.
