Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab2ITIqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 04:46:38 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53422 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab2ITIqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 04:46:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120920000313.GH2455@linux.vnet.ibm.com>
References: <CACRpkdYgxsF1G7Dc_xCcQcFV9G+foz1czOCmROcMQ5NfR-ziCA@mail.gmail.com>
	<50520E8A.9030408@linaro.org>
	<20120913165844.GW4257@linux.vnet.ibm.com>
	<CACRpkdatjfk_eUof5G4fwa-Qf8SoF_NvSUJQAZ7U8yjcSYFuTA@mail.gmail.com>
	<20120914175322.GI4257@linux.vnet.ibm.com>
	<CACRpkdbw+VgaV26U6uZeKr9g28ax2shrieQSxFuj-Pi9RXPtLQ@mail.gmail.com>
	<20120920000313.GH2455@linux.vnet.ibm.com>
Date: Thu, 20 Sep 2012 10:46:34 +0200
Message-ID: <CACRpkdaOG59CNvqUGFer+1TcVM8ovJwxmc3ZryJKw--PJ=bzsQ@mail.gmail.com>
Subject: Re: RCU lockup in the SMP idle thread, help...
From: Linus Walleij <linus.walleij@linaro.org>
To: paulmck@linux.vnet.ibm.com, Nicolas Pitre <nico@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 2:03 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:

> Any thoughts on the feasibility of implementing NMI-based stack backtraces
> for ARM?

Nico's department, so let's page him.

In IIRC ux500 all NMIs are reserved for the secure world, so it's
basically a no can do. :-(

And I'm told this is the case in some other ARMv7 arches too.

> In the meantime, a crude fallback is for the CPU that detected the stall
> to trace the stack of the task running on the other CPU.  See below for
> a crude (and untested) patch.

I'll test!

Thanks,
Linus Walleij
