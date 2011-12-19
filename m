Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab1LSQQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 11:16:33 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49663 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab1LSQQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 11:16:30 -0500
Message-ID: <4EEF6360.4000306@gmail.com>
Date: Mon, 19 Dec 2011 11:16:32 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Rik van Riel <riel@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Android low memory killer vs. memory pressure notifications
References: <20111219025328.GA26249@oksana.dev.rtsoft.ru> <20111219103954.354d68af@pyramind.ukuu.org.uk>
In-Reply-To: <20111219103954.354d68af@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(12/19/11 5:39 AM), Alan Cox wrote:
>>    The main downside of this approach is that mem_cg needs 20 bytes per
>>    page (on a 32 bit machine). So on a 32 bit machine with 4K pages
>>    that's approx. 0.5% of RAM, or, in other words, 5MB on a 1GB machine.
>
> The obvious question would be why? Would fixing memcg make more sense ?

Just historical reason. Initial memcg implement by IBM was just crap. 
People need very long time to fix it.


> The only problem I see with having a user space manager is that manager
> probably has to be mlock to avoid awkward fail cases and that may in fact
> make it smaller kernel side.


