Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab1LTAat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 19:30:49 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54795 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab1LTAas convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 19:30:48 -0500
MIME-Version: 1.0
In-Reply-To: <4EEF6240.9020107@gmail.com>
References: <20111219025328.GA26249@oksana.dev.rtsoft.ru>
	<4EEF6240.9020107@gmail.com>
Date: Tue, 20 Dec 2011 09:30:46 +0900
Message-ID: <CABEgKgrnTN6YbtPbuifyEvgUi7MB47VriVhn8EAAds1k2O83XA@mail.gmail.com>
Subject: Re: Android low memory killer vs. memory pressure notifications
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Rik van Riel <riel@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/20 KOSAKI Motohiro <kosaki.motohiro@gmail.com>:
>> - Use memory controller cgroup (CGROUP_MEM_RES_CTLR) notifications from
>>   the kernel side, plus userland "manager" that would kill applications.
>>
>>   The main downside of this approach is that mem_cg needs 20 bytes per
>>   page (on a 32 bit machine). So on a 32 bit machine with 4K pages
>>   that's approx. 0.5% of RAM, or, in other words, 5MB on a 1GB machine.
>>
>>   0.5% doesn't sound too bad, but 5MB does, quite a little bit. So,
>>   mem_cg feels like an overkill for this simple task (see the driver at
>>   the very bottom).
>
>
> Kamezawa-san, Is 20bytes/page still correct now? If I remember correctly,
> you improved space efficiency of memcg.
>
Johannes removed 4 bytes. It's in upstream.
Johannes removed 8bytes. It's now in linux-next.
I'm preparing a patch to remove more 4 bytes.

Thanks,
-Kame
