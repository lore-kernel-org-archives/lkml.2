Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab1GDBHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 21:07:34 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33653 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab1GDBHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 21:07:33 -0400
Date: Sun, 3 Jul 2011 21:07:23 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Per Forlin <per.forlin@linaro.org>
cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        Nickolay Nickolaev <nicknickolaev@gmail.com>
Subject: Re: [PATCH v8 00/12] use nonblock mmc requests to minimize latency
In-Reply-To: <CAJ0pr1_Rd754qJ+jP9rqbez-9NAOwbxorziQrGDA0yrSMpPsxw@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1107032105010.14596@xanadu.home>
References: <1309248717-14606-1-git-send-email-per.forlin@linaro.org> <201107011844.44058.arnd@arndb.de> <20110702122938.GI21898@n2100.arm.linux.org.uk> <201107022137.30138.arnd@arndb.de> <CAJ0pr1_Rd754qJ+jP9rqbez-9NAOwbxorziQrGDA0yrSMpPsxw@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jul 2011, Per Forlin wrote:

> On 2 July 2011 21:37, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Saturday 02 July 2011 14:29:38 Russell King - ARM Linux wrote:
> >> One other thing to be considered here is whether this idea should be
> >> limited to just MMC or whether it should be extended further, to
> >> move the DMA mapping stuff out of the hot path for other block devices
> >> too.
> >>
> >> There are ARM systems with SATA which do 28MB/s - which could be
> >> improved by this technique.
> >
> > Excellent point. We had discussed SATA items in the context of Linaro
> > work before, and the conclusion was always that we wouldn't need to
> > do any work for it in the common code. I'll make sure that we bring
> > it up at the meeting next month in Cambridge so we can officially
> > assign someone to do this.
> >
> Arnd, do you know if any of the Linaro boards have SATA?

The latest i.mx53 boards have SATA.


Nicolas
