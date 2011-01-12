Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab1ALOLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 09:11:10 -0500
Received: from 1.77.mail-out.ovh.net ([87.98.185.206]:37921 "HELO
	77.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751286Ab1ALOLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 09:11:08 -0500
X-Greylist: delayed 96310 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jan 2011 09:11:08 EST
Message-ID: <4D2DB674.4030900@example.com>
Date: Wed, 12 Jan 2011 15:11:00 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error in linux-2.6.37-git5 in btrfs in ctree.c
References: <4D2C52E3.2020702@example.com> <20110111131423.GA17312@hack>
In-Reply-To: <20110111131423.GA17312@hack>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 13147977639110996248
X-Ovh-Remote: 79.185.218.39 (adtg39.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-Ovh-Tracer-Id: 13411156740909723928
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.01.2011 14:14, Américo Wang wrote:
> On Tue, Jan 11, 2011 at 01:53:55PM +0100, Piotr Hosowicz wrote:
>> (I send again because my previous message wasn't delivered.)
>>
>> Hello,
>>
>> There is an error in here:
>>
>> In file included from fs/btrfs/ctree.c:21:
>> fs/btrfs/ctree.h:1003: error: field ‘super_kobj’ has incomplete type
>> fs/btrfs/ctree.h:1074: error: field ‘root_kobj’ has incomplete type
>>
>> Kernel fails to build. linux-2.6.37-git5

I see that it's the same in Linus GIT tree, I didn't fail to build, 
because I corrected the same way first, it's building now. Should it be 
like that?

Regards,

Piotr Hosowicz

-- 
Grupa marzeń w eliminacjach MŚ :
Zimbabwe, Alaska, Grenlandia, Antarktyda i Zair.
NP: Peter Green Splinter Group - Turn Your Love Away
NB: 2.6.37-git7-corr
