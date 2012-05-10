Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761575Ab2EJVhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:37:18 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:60380 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759365Ab2EJVhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:37:15 -0400
Message-ID: <4FAC3518.6050107@xenotime.net>
Date: Thu, 10 May 2012 14:37:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH -next] wireless: TI wlxxx depends on MAC80211
References: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>		 <4F8C784B.2040402@xenotime.net>	 <1336049755.12189.30.camel@cumari.coelho.fi>	 <4FAC3249.3060107@xenotime.net> <1336685777.12189.142.camel@cumari.coelho.fi>
In-Reply-To: <1336685777.12189.142.camel@cumari.coelho.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 02:36 PM, Luciano Coelho wrote:

> Hey Randy,
> 
> On Thu, 2012-05-10 at 14:25 -0700, Randy Dunlap wrote:
>> On 05/03/2012 05:55 AM, Luciano Coelho wrote:
>>
>>> On Mon, 2012-04-16 at 12:51 -0700, Randy Dunlap wrote:
>>>> From: Randy Dunlap <rdunlap@xenotime.net>
>>>>
>>>> wl12xx build fails with many undefined symbol errors when MAC80211
>>>> and CFG80211 are not enabled, so make WLCORE and WL12XX depend
>>>> on MAC80211 (which already depends on CFG80211).
>>>>
>>>> Here are a few of the many build errors:
> 
> [...]
> 
>>>> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>>>> Cc:	Luciano Coelho <coelho@ti.com>
>>>> Cc:	linux-wireless@vger.kernel.org
>>>> Cc:	"John W. Linville" <linville@tuxdriver.com>
>>>> ---
>>>
>>> Applied! Thanks Randy, and sorry for the delay in pushing this through
>>> my tree.
>>
>>
>>
>> Ping.
>>
>> This patch is still needed in linux-next of 20120510.
> 
> I already applied this patch and sent a pull-request to Linville, but he
> hasn't pulled from my tree into wireless-next yet.
> 
> Would it make sense for you to pull directly from my tree into
> linux-next?


No, I'm just testing/reporting on linux-next.

Thanks.

-- 
~Randy
