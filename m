Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab1BNHfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 02:35:24 -0500
Received: from stinky.trash.net ([213.144.137.162]:47724 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab1BNHfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 02:35:22 -0500
Message-ID: <4D58DB20.5060401@trash.net>
Date: Mon, 14 Feb 2011 08:34:56 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@suug.ch>
Subject: Re: linux-next: Tree for February 10 (netfilter)
References: <20110210180525.54ec83e9.sfr@canb.auug.org.au> <20110210095210.6fcf3011.randy.dunlap@oracle.com>
In-Reply-To: <20110210095210.6fcf3011.randy.dunlap@oracle.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.02.2011 18:52, Randy Dunlap wrote:
> On Thu, 10 Feb 2011 18:05:25 +1100 Stephen Rothwell wrote:
> 
>> Hi all,
>>
>> [The kernel.org mirroring is being slow ...]
>>
>> Changes since 20110209:
> 
> 
> xt_AUDIT.c:(.text+0x39ca9): undefined reference to `ipv6_skip_exthdr'
> 
> IPV6 is not enabled.
> 
> Full config file is attached.

Thomas, please have a look at this.
