Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab2DBVFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:05:05 -0400
Received: from uhura.skim.hs-owl.de ([193.174.118.81]:43527 "EHLO
	uhura.skim.hs-owl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2DBVFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:05:03 -0400
Message-ID: <4F7A1474.20503@googlemail.com>
Date: Mon, 2 Apr 2012 23:04:52 +0200
From: Jan Seiffert <kaffeemonster@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120327 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Matt Turner <mattst88@gmail.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Matt Evans <matt@ozlabs.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, <linux-arch@vger.kernel.org>,
        <linux-alpha@vger.kernel.org>, <rth@redhat.com>
Subject: Re: [PATCH V1 1/1] NET: add a bpf jit for Alpha
References: <4F75CA89.4010709@googlemail.com> <4F7A033D.4040901@googlemail.com> <CAEdQ38FnZXLiPM4CtOhT5X9qj9jLt84x=NhcSSbGO1agSNc24w@mail.gmail.com>
In-Reply-To: <CAEdQ38FnZXLiPM4CtOhT5X9qj9jLt84x=NhcSSbGO1agSNc24w@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Skim-SendBy: exchange.hs-owl.de on Mon, 02 Apr 2012 23:04:57 +0200
X-SA-Exim-Connect-IP: 193.174.118.178
X-SA-Exim-Mail-From: kaffeemonster@googlemail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Turner schrieb:
> On Mon, Apr 2, 2012 at 3:51 PM, Jan Seiffert
> <kaffeemonster@googlemail.com> wrote:
>> The weekend was cold and windy, so i wrote a bpf jit for the Alpha architecture.
>>
>> Signed-off-by: Jan Seiffert <kaffeemonster@googlemail.com>
>>
>> ---
>>
>> Patch is against net-next and needs Patch 1 of my "Fix negative offsets" Series
>> (to get bpf_internal_load_pointer_neg_helper)
>>
>> The Problem is: i don't have any Alpha machine nor do i really have any clue about
>> the arch.
>> So this is only compile tested.
>> I could really need some Alpha asm guru to give some advice and review this.
>> Are the calls done right, are the asm load helper ok, all the conditional and
>> sign handling is a little brittle in my mind, etc.
> 
> Very cool. I'll try to find some time soon to test this.
> 

That would be great.
But make sure to fasten your seat belts, it will prop. crash hard ;)
Here is a link to the Patch 1 you also need:
<http://marc.info/?l=linux-kernel&m=133312658915220&w=2>

> Thanks a lot!
> Matt
> 

Greetings
	Jan

-- 
Wherever I lay my .vimrc, there's my $HOME.
