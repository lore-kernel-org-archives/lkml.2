Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab2CJQpW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 11:45:22 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:60777 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753286Ab2CJQpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 11:45:18 -0500
Message-ID: <4F5B8522.8050707@xenotime.net>
Date: Sat, 10 Mar 2012 08:45:22 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: linux-next: Tree for Mar 9 (netfilter)
References: <20120309191101.8634973f7d9988c602143f7c@canb.auug.org.au> <4F5A6872.3050502@xenotime.net> <20120310112154.GA22478@1984>
In-Reply-To: <20120310112154.GA22478@1984>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2012 03:21 AM, Pablo Neira Ayuso wrote:

> On Fri, Mar 09, 2012 at 12:30:42PM -0800, Randy Dunlap wrote:
>> On 03/09/2012 12:11 AM, Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> There will be no linux-next release on March 12 due to a public holiday.
>>>
>>> Changes since 20120308:
>>
>>
>> xt_LOG.c:(.text+0x789b1): undefined reference to `ip6t_ext_hdr'
>>
>> Full randconfig file is attached.
> 
> The patch attached fixes this problem, thanks!


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

-- 
~Randy
