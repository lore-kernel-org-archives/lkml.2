Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab0IMGuC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 02:50:02 -0400
Received: from [83.228.35.12] ([83.228.35.12]:48656 "EHLO fs.ru.acad.bg"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab0IMGt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 02:49:59 -0400
Message-ID: <4C8DC995.3060206@fs.uni-ruse.bg>
Date: Mon, 13 Sep 2010 09:49:57 +0300
From: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; bg; rv:1.9.1.12) Gecko/20100824 Thunderbird/3.0.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: rjw@sisk.pl, jarkao2@gmail.com, eric.dumazet@gmail.com,
        herbert@gondor.hengli.com.au, kernel-testers@vger.kernel.org,
        maciej.rutecki@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, stable@kernel.org
Subject: Re: [Bug #16626] Machine hangs with EIP at skb_copy_and_csum_dev
References: <20100908.103256.112592448.davem@davemloft.net>	<201009082221.16356.rjw@sisk.pl>	<4C8C7957.7080207@fs.uni-ruse.bg> <20100912.085509.193705327.davem@davemloft.net>
In-Reply-To: <20100912.085509.193705327.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

На 12.9.2010 г. 18:55, David Miller написа:
> From: Plamen Petrov<pvp-lsts@fs.uni-ruse.bg>
> Date: Sun, 12 Sep 2010 09:55:19 +0300
>
>> Now that both commits that fix my problems are in Linus' tree, the
>> bug can be closed, but these fixes should go in 2.6.35.y, too.
>> So, CCing -stable.
>
> You don't need to do this, I will submit whatever is appropriate for
> networking to -stable as needed.

Sorry! I didn't know it will be taken care of.

Thanks!
Plamen
