Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab2DEMWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 08:22:19 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:35207 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab2DEMWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 08:22:18 -0400
Message-ID: <4F7D8E64.2020508@parallels.com>
Date: Thu, 05 Apr 2012 16:21:56 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: kernel BUG at include/net/netns/generic.h:41
References: <20120328002346.GB3077@redhat.com>	 <20120402172600.GA3728@redhat.com> <1333390230.13718.34.camel@lade.trondhjem.org>
In-Reply-To: <1333390230.13718.34.camel@lade.trondhjem.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

02.04.2012 22:10, Myklebust, Trond пишет:
> This looks related to the recent net namespace changes, so I'm adding
> Stanislav.
>
> Cheers
>    Trond
>
> On Mon, 2012-04-02 at 13:26 -0400, Dave Jones wrote:
>> [added Trond to cc:]
>>
>> still seeing this in 3.4rc1
>>

Hello, Dave.
Could you reply with your kernel config to this letter?

-- 
Best regards,
Stanislav Kinsbursky
