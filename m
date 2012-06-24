Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab2FXPog (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 11:44:36 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:35313 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750967Ab2FXPoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 11:44:34 -0400
Message-ID: <4FE735C4.8000308@xenotime.net>
Date: Sun, 24 Jun 2012 08:44:04 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-next@vger.kernel.org, Joe Thornber <dm-devel@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: Re: mmotm 2012-06-21-16-20 uploaded (dm-thin)
References: <20120621232149.F0286A026A@akpm.mtv.corp.google.com>	<4FE4AAAE.3090803@xenotime.net> <20120625004425.5efce7fbca77b7cfa086922a@canb.auug.org.au>
In-Reply-To: <20120625004425.5efce7fbca77b7cfa086922a@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2012 07:44 AM, Stephen Rothwell wrote:

> Hi Randy,
> 
> On Fri, 22 Jun 2012 10:26:06 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:
>>
>> on i386:
>>
>> Apparently from linux-next.patch:
>>
>> drivers/built-in.o: In function `thin_iterate_devices':
>> dm-thin.c:(.text+0x206f07): undefined reference to `__udivdi3'
>> drivers/built-in.o: In function `pool_preresume':
>> dm-thin.c:(.text+0x207863): undefined reference to `__udivdi3'
> 
> I assume that CONFIG_LDBAF is not set and I think this is caused by
> commit ebf5d9e0425c ("Non power of 2 blocksize support is needed to
> properly align thinp IO") from the device-mapper tree.
> 


Correct:
# CONFIG_LBDAF is not set


thanks,
-- 
~Randy
