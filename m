Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab1LSQZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 11:25:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab1LSQZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 11:25:06 -0500
Message-ID: <4EEF6532.3090201@redhat.com>
Date: Mon, 19 Dec 2011 11:24:18 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        =?UTF-8?B?QXJ2ZSBIasO4?= =?UTF-8?B?bm5ldsOlZw==?= 
	<arve@android.com>,
        Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Android low memory killer vs. memory pressure notifications
References: <20111219025328.GA26249@oksana.dev.rtsoft.ru> <20111219103954.354d68af@pyramind.ukuu.org.uk> <4EEF6360.4000306@gmail.com>
In-Reply-To: <4EEF6360.4000306@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 11:16 AM, KOSAKI Motohiro wrote:
> (12/19/11 5:39 AM), Alan Cox wrote:
>>> The main downside of this approach is that mem_cg needs 20 bytes per
>>> page (on a 32 bit machine). So on a 32 bit machine with 4K pages
>>> that's approx. 0.5% of RAM, or, in other words, 5MB on a 1GB machine.
>>
>> The obvious question would be why? Would fixing memcg make more sense ?
>
> Just historical reason. Initial memcg implement by IBM was just crap.

And the reason for that, I suspect, is that the "proper"
implementation changes the VM by so much that it would
never have been merged in the first place...

-- 
All rights reversed
