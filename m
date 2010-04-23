Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab0DWMAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 08:00:18 -0400
Received: from smtp.nokia.com ([192.100.122.233]:50291 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300Ab0DWMAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 08:00:16 -0400
Subject: Re: [PATCH v2] MTD: Fix Orion NAND driver compilation with ARM OABI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Cc: dwmw2@infradead.org, Nicolas Pitre <nico@fluxnic.net>, jamie@shareable.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       u.kleine-koenig@pengutronix.de, simon.kagstrom@netinsight.net,
       akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <4BB33988.9070608@gmail.com>
References: <20100325152505.17612.40158.stgit@pauliusz>
	 <alpine.LFD.2.00.1003251225500.694@xanadu.home>
	 <4BB33988.9070608@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Apr 2010 14:56:18 +0300
Message-ID: <1272023778.6917.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Apr 2010 11:59:26.0093 (UTC) FILETIME=[6BB113D0:01CAE2DC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 15:01 +0300, Paulius Zaleckas wrote:
> On 03/25/2010 06:26 PM, Nicolas Pitre wrote:
> > On Thu, 25 Mar 2010, Paulius Zaleckas wrote:
> >
> >> We must tell GCC to use even register for variable passed
> >> to ldrd instruction. Without this patch GCC 4.2.1 puts this
> >> variable to r2/r3 on EABI and r3/r4 on OABI, so force it to
> >> r2/r3. This does not change anything when EABI and OABI
> >> compilation works OK.
> >>
> >> Without this patch and with OABI I get:
> >>    CC      drivers/mtd/nand/orion_nand.o
> >> /tmp/ccMkwOCs.s: Assembler messages:
> >> /tmp/ccMkwOCs.s:63: Error: first destination register must be even -- `ldrd r3,[ip]'
> >> make[5]: *** [drivers/mtd/nand/orion_nand.o] Error 1
> >>
> >> Signed-off-by: Paulius Zaleckas<paulius.zaleckas@gmail.com>
> >
> > Acked-by: Nicolas Pitre<nico@fluxnic.net>
> 
> David,
> 
> Will you take this patch?
> Or you are waiting till I will add all Cc as Jamie suggested?

Meanwhile, I've pushed your patch to my l2-mtd-2.6.git / dunno.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

