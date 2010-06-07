Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab0FGM5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:57:18 -0400
Received: from king.tilera.com ([72.1.168.226]:30455 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab0FGM5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:57:17 -0400
Message-ID: <4C0CEC99.3020909@tilera.com>
Date: Mon, 07 Jun 2010 08:56:57 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: build failure after merge of the final tree (tile
 tree related)
References: <20100607140140.870c0fb5.sfr@canb.auug.org.au>
In-Reply-To: <20100607140140.870c0fb5.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jun 2010 12:56:59.0970 (UTC) FILETIME=[EAF3A220:01CB0640]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/2010 12:01 AM, Stephen Rothwell wrote:
> I applied this patch for today.  Something better could probably be
> done.  I note that there is already a declaration of sys_rt_sigaction in
> include/asm-generic/syscalls.h ...
>   

Yes, thanks for the pointer.  In fact by adjusting a couple of tile
syscalls slightly I can just use <asm-generic/syscalls.h> wholesale.  I
reverted the addition of sys_rt_sigaction() and sys_rt_sigsuspend() to
<linux/syscalls.h> and cleaned up the arch/tile/include/asm/syscalls.h
as well.  I mailed the patch as another reply-to to Stephen's original
message.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


