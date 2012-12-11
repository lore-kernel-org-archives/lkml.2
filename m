Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab2LKEsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 23:48:22 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34684 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2LKEsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 23:48:20 -0500
Date: Mon, 10 Dec 2012 23:48:17 -0500 (EST)
Message-Id: <20121210.234817.805113114715558868.davem@davemloft.net>
To: abhi.c.pawar@gmail.com
Cc: pablo@netfilter.org, kaber@trash.net, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, linville@tuxdriver.com,
        johannes@sipsolutions.net, amwang@redhat.com, edumazet@google.com,
        nhorman@tuxdriver.com, joe@perches.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH RESEND] net: remove obsolete simple_strto<foo>
From: David Miller <davem@davemloft.net>
In-Reply-To: <50C6A995.1020908@gmail.com>
References: <1355130748-7828-1-git-send-email-abhi.c.pawar@gmail.com>
	<20121210.141002.450030380391247897.davem@davemloft.net>
	<50C6A995.1020908@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijit Pawar <abhi.c.pawar@gmail.com>
Date: Tue, 11 Dec 2012 09:03:41 +0530

> On 12/11/2012 12:40 AM, David Miller wrote:
>> From: Abhijit Pawar <abhi.c.pawar@gmail.com>
>> Date: Mon, 10 Dec 2012 14:42:28 +0530
>> 
>>> This patch replace the obsolete simple_strto<foo> with kstrto<foo>
>>>
>>> Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
>> 
>> Applied.
>> 
> Hi David,
> It seems that there are occurences of simple_strto* still present in the
> couple of files which are not yet removed correctly by this patch. I
> will send a modified patch shortly. Please revert this commit and use
> the newly sent patch to merge with the tree.

Again, you cannot send "modified" patches.

When I say I've applied your patch, that cannot be undone.

You must therefore send me fixup patches relative to the ones
I've applied already.
