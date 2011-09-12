Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1ILSnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 14:43:06 -0400
Received: from mail.tpi.com ([70.99.223.143]:3353 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab1ILSnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 14:43:03 -0400
Message-ID: <4E6E52B1.1070405@canonical.com>
Date: Mon, 12 Sep 2011 12:42:57 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: kaber@trash.net
CC: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Check net->nfnl for NULL in ctnetlink_conntrack_event
 to, avoid Oops on container destroy
References: <4E6E4961.9070802@canonical.com>
In-Reply-To: <4E6E4961.9070802@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2011 12:03 PM, Tim Gardner wrote:
> Patrick,
>
> I received this patch from a developer that uses lxc and network name
> spaces. I don't know the locking semantics well enough for CT to judge
> whether this fix is sufficient. Bug info can be found at
> http://bugs.launchpad.net/bugs/843892 . See comment #7 for his analysis.
>
> rtg

Never mind. Looks like Alex already sent this patch on Sept 10 with the 
subject 'Fix repeatable Oops on container destroy with conntrack'.

rtg

-- 
Tim Gardner tim.gardner@canonical.com
