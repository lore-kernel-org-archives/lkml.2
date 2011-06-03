Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab1FCTvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 15:51:23 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:57851 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab1FCTvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 15:51:21 -0400
Message-ID: <4DE93B31.8040700@ahsoftware.de>
Date: Fri, 03 Jun 2011 21:51:13 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>, netdev@vger.kernel.org
Subject: Re: bridge/netfilter: regression in 2.6.39.1
References: <4DE93422.3070000@ahsoftware.de> <1307129642.2600.2.camel@edumazet-laptop>
In-Reply-To: <1307129642.2600.2.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 03.06.2011 21:34, schrieb Eric Dumazet:
>>
>> Commit 42923465fb8d025a2b5153f2e7ab1e6e1058bf00 does here what it
>> should prevent, it introduces NULL a dereference.
>>
>
> I cant find this commit in known trees. Could you give the real commit
> id and its title ?

Sorry, I haven't seen that question at first. This is the real commit id 
as found in the stable tree for 2.6.39. The title of that commit is
"bridge: initialize fake_rtable metrics"

Regards,

Alexander
