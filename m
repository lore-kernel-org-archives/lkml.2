Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1KAMsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:48:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61776 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab1KAMsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:48:51 -0400
MIME-Version: 1.0
In-Reply-To: <20111101114242.7c90f958@bob.linux.org.uk>
References: <1319772453-1275-1-git-send-email-Barry.Song@csr.com>
 <20111028071129.GA2362@tarshish> <CAGsJ_4z=VtU+RJ4c0Y2ruttWU6mTVtHMxzvCYWGz=5w6i7QJMQ@mail.gmail.com>
 <20111101114242.7c90f958@bob.linux.org.uk>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 1 Nov 2011 20:48:29 +0800
Message-ID: <CAGsJ_4wGRv9=fbWtK-0jkmXDcd=y2r6qxae99tNgim4=BmxJ+w@mail.gmail.com>
Subject: Re: [PATCH] UART: add CSR SiRFprimaII SoC on-chip uart drivers
To: Alan Cox <alan@linux.intel.com>, torvalds@linux-foundation.org
Cc: Baruch Siach <baruch@tkos.co.il>, Rong Wang <Rong.Wang@csr.com>,
        Bin Shi <Bin.Shi@csr.com>, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        linux-serial@vger.kernel.org, Barry Song <Baohua.Song@csr.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/1 Alan Cox <alan@linux.intel.com>:
>> i am not sure whether i will make Linus confused if i send a new
>> version at this moment. how about i send a seperate patch to fix this
>> after the driver is applied?
>
> That would be the best idea - its a trivial typo so doesn't really
> matter much.
ok, Alan.

Linus, have you gotten it? and can you apply it?
or do you want this to go through tty tree and merge it until next merge window?

-barry
