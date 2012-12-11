Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab2LKDeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 22:34:21 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38329 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab2LKDeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 22:34:19 -0500
Message-ID: <50C6A995.1020908@gmail.com>
Date: Tue, 11 Dec 2012 09:03:41 +0530
From: Abhijit Pawar <abhi.c.pawar@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: abhi.c.pawar@gmail.com, pablo@netfilter.org, kaber@trash.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        linville@tuxdriver.com, johannes@sipsolutions.net, amwang@redhat.com,
        edumazet@google.com, nhorman@tuxdriver.com, joe@perches.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH RESEND] net: remove obsolete simple_strto<foo>
References: <1355130748-7828-1-git-send-email-abhi.c.pawar@gmail.com> <20121210.141002.450030380391247897.davem@davemloft.net>
In-Reply-To: <20121210.141002.450030380391247897.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 12:40 AM, David Miller wrote:
> From: Abhijit Pawar <abhi.c.pawar@gmail.com>
> Date: Mon, 10 Dec 2012 14:42:28 +0530
> 
>> This patch replace the obsolete simple_strto<foo> with kstrto<foo>
>>
>> Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
> 
> Applied.
> 
Hi David,
It seems that there are occurences of simple_strto* still present in the
couple of files which are not yet removed correctly by this patch. I
will send a modified patch shortly. Please revert this commit and use
the newly sent patch to merge with the tree.

-- 
-
Abhijit
