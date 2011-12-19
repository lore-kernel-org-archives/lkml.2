Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab1LSQLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 11:11:45 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51901 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1LSQLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 11:11:43 -0500
Message-ID: <4EEF6240.9020107@gmail.com>
Date: Mon, 19 Dec 2011 11:11:44 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        =?UTF-8?B?QXJ2ZSBIag==?= =?UTF-8?B?w7hubmV2w6Vn?= 
	<arve@android.com>,
        Rik van Riel <riel@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: Android low memory killer vs. memory pressure notifications
References: <20111219025328.GA26249@oksana.dev.rtsoft.ru>
In-Reply-To: <20111219025328.GA26249@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - Use memory controller cgroup (CGROUP_MEM_RES_CTLR) notifications from
>    the kernel side, plus userland "manager" that would kill applications.
>
>    The main downside of this approach is that mem_cg needs 20 bytes per
>    page (on a 32 bit machine). So on a 32 bit machine with 4K pages
>    that's approx. 0.5% of RAM, or, in other words, 5MB on a 1GB machine.
>
>    0.5% doesn't sound too bad, but 5MB does, quite a little bit. So,
>    mem_cg feels like an overkill for this simple task (see the driver at
>    the very bottom).

Kamezawa-san, Is 20bytes/page still correct now? If I remember 
correctly, you improved space efficiency of memcg.

