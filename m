Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365Ab2DJBwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 21:52:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab2DJBwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 21:52:17 -0400
Message-ID: <4F83923E.6010802@redhat.com>
Date: Mon, 09 Apr 2012 21:51:58 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: werner <w.landgraf@ru.ru>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, rientjes@google.com
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1 sticks-and-crashs)
References: <web-723115389@zbackend1.aha.ru>
In-Reply-To: <web-723115389@zbackend1.aha.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 09:52 PM, werner wrote:
> At least until now, and also tested hard by starting and stopping
> several memory-consuming operations, I'm happy to can inform that the
> computer didnt yet crash again, and that also slownessnesses what I
> observed under 3.3 (but without crashs) don't occur

That could be due to a few VM patches which I wrote, that
went in through -mm.

I am very interested in whether people do find a way to
break the VM with those patches, in ways that used to work
before.

If you find any, please let me know so I can fix them
before the 3.4 kernel comes out.

If everything you try works better than before, I'm not
going to complain about good news :)

-- 
All rights reversed
