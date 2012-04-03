Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab2DCWb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 18:31:58 -0400
Received: from uhura.skim.hs-owl.de ([193.174.118.81]:38327 "EHLO
	uhura.skim.hs-owl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab2DCWb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 18:31:57 -0400
Message-ID: <4F7B7A59.2090904@googlemail.com>
Date: Wed, 4 Apr 2012 00:31:53 +0200
From: Jan Seiffert <kaffeemonster@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120327 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <eric.dumazet@gmail.com>
Subject: Re: [REGRESSION][PATCH V4 3/3] bpf jit: Let the powerpc jit handle
 negative offsets
References: <4F75CA89.4010709@googlemail.com> <4F75D2A5.7060407@googlemail.com> <20120403.180302.342779808900865443.davem@davemloft.net>
In-Reply-To: <20120403.180302.342779808900865443.davem@davemloft.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Skim-SendBy: exchange.hs-owl.de on Wed, 04 Apr 2012 00:31:55 +0200
X-Skim-SendBy: exchange.hs-owl.de on Wed, 04 Apr 2012 00:31:56 +0200
X-SA-Exim-Connect-IP: 193.174.118.178
X-SA-Exim-Mail-From: kaffeemonster@googlemail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller schrieb:
[snip - my patch description]
> 
> I'm not applying this until a powerpc person tests it.
> 

As Benjamin already said, Matt is having a look, so i expected nothing else.

> Also, we have an ARM JIT in the tree which probably needs to
> be fixed similarly.
> 

???
Oh, in which tree is it?
I was working against net-next.

Greetings
	Jan


-- 
˙qɐɥ ʇɟnɐʞǝƃ ʎɐqǝ ıǝq ɹnʇɐʇsɐʇ ǝuıǝ ɹıɯ ɥɔı sɐp lɐɯ ǝʇzʇǝl sɐp ʇsı sɐp 
'ʇɯɯɐpɹǝʌ
