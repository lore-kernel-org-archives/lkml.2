Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab1IIAYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 20:24:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57498 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779Ab1IIAX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 20:23:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Barry Song <21cnbao@gmail.com>, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Rongjun Ying <rongjun.ying@csr.com>, Barry Song <Baohua.Song@csr.com>,
        dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
Date: Thu, 08 Sep 2011 22:11:31 +0200
Message-ID: <2264116.VTHb2BIH5a@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <CAKnu2Mpnjec-hvfbT0zH1P2mGZKNwTQYgDLGHWUXLmGGQB0_ow@mail.gmail.com>
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com> <201109081819.30035.arnd@arndb.de> <CAKnu2Mpnjec-hvfbT0zH1P2mGZKNwTQYgDLGHWUXLmGGQB0_ow@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ochUHTFzaa/wyK5GqkBRSs5EWVOPdS31TZrqlRZ7aNQ
 4q4wbyyVbiFMGRD/aWbbcX2XrLXJJfR/fbUlbNe1n9UBzULrtt
 0D0+HZxCus7V+7NdlzGk/O7olMFdy+q6MqJwT70rwvOaeEklov
 DGtuqKJ1Sgzyq9+jv9T+uBJQDYxmt0bbYwv+UsV2EoNE2VMEL6
 KRK5WRbZ0Bb7nkhYF5nNZLlAqF0FwAt7SZk4qdQQQeJnUB6cIc
 mpY5eslxgDJxES2iElHzw0ffpyLrpVs96ZvMQOsFgx6HFhoc2h
 LHv0mIjZDheI97ziwygdFwYa8y3zVW6ZWHRo6rCvRPszHfjB+c
 qINVoRuyjlfsC/yCDVcI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 September 2011 20:48:26 Linus Walleij wrote:
> 2011/9/8 Arnd Bergmann <arnd@arndb.de>:
> > On Thursday 08 September 2011, Barry Song wrote:
> >>
> >> this filter is used by all drivers with DMA since every dma channel is
> >> fixed to be assigned to one device.
> >
> > Ok, I see now. I think it would be best to introduce a generic
> > 'filter by device tree property' function or alternatively an
> > dma_of_request_channel function like this:
> 
> You'd have to discuss that with Vinod, the thing is that x86 Atom
> systems are using dmaengine for device slave transfers too, and
> IIRC these things don't use devicetrees. I may be wrong...

Some of them use device tree, some don't.

I'm not saying that we have to convert all drivers to use this, but
for platforms that always have device tree available, it seems by far
the cleanest solution.

	Arnd
