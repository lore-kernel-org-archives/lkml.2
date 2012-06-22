Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762631Ab2FVR0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 13:26:34 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:40109 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762587Ab2FVR0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 13:26:32 -0400
Message-ID: <4FE4AAAE.3090803@xenotime.net>
Date: Fri, 22 Jun 2012 10:26:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, linux-next@vger.kernel.org,
        Joe Thornber <dm-devel@redhat.com>, dm-devel@redhat.com
Subject: Re: mmotm 2012-06-21-16-20 uploaded (dm-thin)
References: <20120621232149.F0286A026A@akpm.mtv.corp.google.com>
In-Reply-To: <20120621232149.F0286A026A@akpm.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 04:21 PM, akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2012-06-21-16-20 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> It contains the following patches against 3.5-rc3:
> (patches marked "*" will be included in linux-next)



on i386:

Apparently from linux-next.patch:

drivers/built-in.o: In function `thin_iterate_devices':
dm-thin.c:(.text+0x206f07): undefined reference to `__udivdi3'
drivers/built-in.o: In function `pool_preresume':
dm-thin.c:(.text+0x207863): undefined reference to `__udivdi3'


-- 
~Randy
