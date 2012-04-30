Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab2D3E1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 00:27:15 -0400
Received: from uhura.skim.hs-owl.de ([193.174.118.81]:52701 "EHLO
	uhura.skim.hs-owl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab2D3E1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 00:27:14 -0400
Message-ID: <4F9E1496.9060603@googlemail.com>
Date: Mon, 30 Apr 2012 06:27:02 +0200
From: Jan Seiffert <kaffeemonster@googlemail.com>
Reply-To: <kaffeemonster@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120327 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: David Miller <davem@davemloft.net>, <eric.dumazet@gmail.com>,
        <matt@ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [REGRESSION][PATCH V4 3/3] bpf jit: Let the powerpc jit handle
 negative offsets
References: <4F75CA89.4010709@googlemail.com>  <4F75D2A5.7060407@googlemail.com>  <20120403.180302.342779808900865443.davem@davemloft.net>  <1333491102.3040.12.camel@pasglop> <1335753820.20866.27.camel@pasglop> <1335759088.20866.32.camel@pasglop>
In-Reply-To: <1335759088.20866.32.camel@pasglop>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Skim-SendBy: exchange.hs-owl.de on Mon, 30 Apr 2012 06:27:10 +0200
X-SA-Exim-Connect-IP: 193.174.118.178
X-SA-Exim-Mail-From: kaffeemonster@googlemail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt schrieb:
> On Mon, 2012-04-30 at 12:43 +1000, Benjamin Herrenschmidt wrote:
> 
>>> Matt's having a look at powerpc
>>
>> Ok, he hasn't so I'll dig a bit.
>>
>> No obvious wrongness (but I'm not very familiar with bpf), though I do
>> have a comment: sk_negative_common() and bpf_slow_path_common() should
>> be made one and single macro which takes the fallback function as an
>> argument.
> 
> Ok, with the compile fix below it seems to work for me:
> 
> (Feel free to fold that into the original patch)
> 

Should i resend the complete patch with the compile fix?

[snip]
>  
> Cheers,
> Ben.
> 


Greetings
	Jan


PS: I am sure i compile tested the orig. patch here, hmmm, must have
lost that part when moving trees, #GitIsNotMyFriend

-- 
en.gin.eer en-ji-nir n 1: a mechanism for converting caffeine into designs.
