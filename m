Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab0LPVn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 16:43:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab0LPVn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 16:43:56 -0500
Message-ID: <4D0A8813.7060909@suse.cz>
Date: Thu, 16 Dec 2010 22:43:47 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        brueckner@linux.vnet.ibm.com, mchehab@redhat.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: visibility changes (was: Re: [GIT] kbuild and kconfig fixes for
 2.6.37-rc5)
References: <AANLkTikVM=zakYF7uhX1mYHy9QUVL6dmEPNsmV7=oyuh@mail.gmail.com>	<AANLkTi=iH6QOAph0iW6MR2khD5KCe8mRLPe8Y3QnTTTW@mail.gmail.com>	<AANLkTik2SWrmVJ1o98-e2CwJP9SAo6oMmnuLc4K+rT1R@mail.gmail.com>	<AANLkTikdNXdDoixEzGbirH+U_v62vDeEMGaRRpvTsJpu@mail.gmail.com> <AANLkTin8Xf9SPcHrBPRPg+cnbWO94CwB4u6KQ2it1+Y9@mail.gmail.com>
In-Reply-To: <AANLkTin8Xf9SPcHrBPRPg+cnbWO94CwB4u6KQ2it1+Y9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7.12.2010 21:45, Geert Uytterhoeven wrote:
> On Tue, Dec 7, 2010 at 21:40, Arnaud Lacombe<lacombar@gmail.com>  wrote:
>> On Tue, Dec 7, 2010 at 3:31 PM, Geert Uytterhoeven<geert@linux-m68k.org>  wrote:
>>> On Tue, Dec 7, 2010 at 20:51, Arnaud Lacombe<lacombar@gmail.com>  wrote:
>>>> On Tue, Dec 7, 2010 at 2:07 PM, Geert Uytterhoeven<geert@linux-m68k.org>  wrote:
>>>>> BTW, I got confused:
>>>>>   - make allmodconfig causes e.g.:
>>>>>         CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
>>>>>         CONFIG_VIDEO_TVAUDIO=m
>>>>>     =>  good
>>>>>   - make oldconfig for my config with almost everything selected,
>>>>> except for stuff I know that breaks:
>>>>>         CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
>>>>>         # CONFIG_VIDEO_TVAUDIO is not set
>>>>>     and no way to manually set CONFIG_VIDEO_TVAUDIO=y?
>>>>>     =>  bad!
>>>> that's difficult to judge without your old configuration.
>>>> VIDEO_TVAUDIO is only selected by VIDEO_BT848 which you don't give
>>>> information about.
>>>
>>> I don't have PCI, so I cannot enable VIDEO_BT848.
>>>
>> so why do you expect VIDEO_TVAUDIO to be enabled ?
>
> I don't expect it to be enabled, I expected to be able to enable it.
> Allmodconfig
> does enable it.

Actually allmodconfig should not enable it, as it did not so before the 
patch. See Jan's fix at https://patchwork.kernel.org/patch/393302/

Michal
