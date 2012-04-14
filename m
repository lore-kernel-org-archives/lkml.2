Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab2DNT65 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 15:58:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859Ab2DNT64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 15:58:56 -0400
Message-ID: <4F89D6F1.8020604@redhat.com>
Date: Sat, 14 Apr 2012 15:58:41 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: werner <w.landgraf@ru.ru>
CC: David Rientjes <rientjes@google.com>, Colin Cross <ccross@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1 sticks-and-crashs)
References: <web-725985845@zbackend1.aha.ru>
In-Reply-To: <web-725985845@zbackend1.aha.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2012 03:38 PM, werner wrote:
> Perhaps someone could check this
>
> Ocasionally it still happens that the computer slows down very, during
> appr. 1 minute (but it dont crash, nor is nothing visible in syslog).
>
> I think this wasn't before approx. the 3.2 kernel, at least I didn't
> perceive it, but this happens at 3.3 and 3.4-rc2-inclusive all patchs.
>
> Below, ps alx and top i printed in a file at an ocasion as this happened
> I observed that then always kmemleak is almost at the beginning of top

I have a feeling you might enjoy things like the sysprof
tool, which can show you not only which process is using
CPU time, but also where it is spent.

-- 
All rights reversed
