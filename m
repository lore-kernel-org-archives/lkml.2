Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab1LHHBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:01:14 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:62339 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab1LHHBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:01:10 -0500
Message-ID: <20192.24749.652755.425707@ipc1.ka-ro>
Date: Thu, 8 Dec 2011 08:01:01 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, shawn.guo@linaro.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/8][NET] fec.c: several cleanups and bugfixes
In-Reply-To: <20111207.133800.1403774147364781100.davem@davemloft.net>
References: <cover.1323256319.git.LW@KARO-electronics.de>
	<20111207.133800.1403774147364781100.davem@davemloft.net>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

David Miller writes:
> From: Lothar Waßmann <LW@KARO-electronics.de>
> Date: Wed,  7 Dec 2011 14:37:12 +0100
> 
> > The following set of patches provides some cleanup and bugfixes for
> > drivers/net/ethernet/freescale/fec.c and makes the driver buildable as
> > a module.
> 
> 1) I said to use a subject prefix of "fec: " not "fec.c: "
> 
OK.

> 2) You did not integrate Shawn's "Acked-by: " tags, I'm not going to
>    go sifting through the previous patch postings to collect them up,
>    that's your job.
>
I still got no Ack from Shawn for patches 3 and 5 and only Tested-by
for patches 6 thru 8. Should I wait for Shawn's Ack for those patches
too, or should I resent now?


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
