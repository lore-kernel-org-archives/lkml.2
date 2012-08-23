Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187Ab2HWRz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:55:29 -0400
Received: from relay1.sgi.com ([192.48.179.29]:41496 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab2HWRz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:55:27 -0400
Message-ID: <50366E70.1020109@sgi.com>
Date: Thu, 23 Aug 2012 12:54:56 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <adobriyan@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] fs/proc: Move kfree outside pde_unload_lock
References: <n>  <1345653510-22000-1-git-send-email-nzimmer@sgi.com>  <1345660110.5158.1969.camel@edumazet-glaptop> <1345671778.5158.2369.camel@edumazet-glaptop>
In-Reply-To: <1345671778.5158.2369.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.156]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 04:42 PM, Eric Dumazet wrote:
> On Wed, 2012-08-22 at 20:28 +0200, Eric Dumazet wrote:
>
>> Thats interesting, but if you really want this to fly, one RCU
>> conversion would be much better ;)
>>
>> pde_users would be an atomic_t and you would avoid the spinlock
>> contention.
> Here is what I had in mind, I would be interested to know how it helps a 512 core machine ;)
>
Thanks, I knew if I just took my time and read the rcu documentation
thoroughly that the answer would be forthcoming. ;)

Unfortunately I have to wait till tomorrow to get big box and test it.


