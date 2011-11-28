Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1K1J6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 04:58:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab1K1J6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 04:58:30 -0500
Message-ID: <4ED35B3E.7040105@redhat.com>
Date: Mon, 28 Nov 2011 09:58:22 +0000
From: Christine Caulfield <ccaulfie@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: swhiteho@redhat.com, eric.dumazet@gmail.com, levinsasha928@gmail.com,
        mpm@selenic.com, cl@linux-foundation.org, penberg@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [BUG] 3.2-rc2: BUG kmalloc-8: Redzone overwritten
References: <1321870529.2552.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <1321870915.2552.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <1321873110.2710.13.camel@menhir> <20111126.155028.1986754382924402334.davem@davemloft.net>
In-Reply-To: <20111126.155028.1986754382924402334.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/11 20:50, David Miller wrote:
> From: Steven Whitehouse<swhiteho@redhat.com>
> Date: Mon, 21 Nov 2011 10:58:30 +0000
>
>> I have to say that I've been wondering lately whether it has got to the
>> point where it is no longer useful. Has anybody actually tested it
>> lately against "real" DEC implementations?
>
> I doubt it :-)
>

DECnet is in use against real DEC implementations - I have checked it 
quite recently against a VAX running OpenVMS. How many people are 
actually using it for real work is a different question though.

It's also true that it's not really supported by anyone as I orphaned it 
some time ago and nobody else seems to care enough to take it over. So 
if it's becoming a burden on people doing real kernel work then I don't 
think many tears will be wept for its removal.

Chrissie
