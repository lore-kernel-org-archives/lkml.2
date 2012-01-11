Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab2AKQqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:46:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:51847 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2AKQqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:46:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: linux-next: manual merge of the v4l-dvb tree with the arm-soc tree
Date: Wed, 11 Jan 2012 16:46:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olof Johansson <olof@lixom.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, "Wu, Josh" <Josh.wu@atmel.com>
References: <20120111133146.990e2b7115c9fa80e8fc3234@canb.auug.org.au> <201201111450.02798.arnd@arndb.de> <4F0DB16B.3010302@atmel.com>
In-Reply-To: <4F0DB16B.3010302@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201111646.24731.arnd@arndb.de>
X-Provags-ID: V02:K0:3fBCWDRbNX0Ip7a0f40zD2i2vCOO0yVxCJMWz17aTfF
 BBY1Q/TIDDmlJIalC+zKdx5hXXUru2dWDefnbsm7Z0zAC977KC
 xE6UhWyNjqp5SPdJ5EExmy+hKt7ZCXBecIrukrGVCnErBUMs43
 //Smm0aoColuMpvsgJcwTNfHTVwAAddDIl63bmeeXpXf9VPHfi
 WEtveUKmhtpeh156l7zyZMEDah8AJxHSmyXGvux/DscPxoR4C2
 yBacOPeZXREecNZKWAiVUd3BpO14vlNL+jaxMTtZcaFQu8w+81
 xXfKi734GtXODN8lYhlXECVkdaOgs7Ztco1cH9l1V4on7+GeKs
 XYd/98KyZHCQ2D8OAEVg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 January 2012, Nicolas Ferre wrote:
> I am so astonished and sad about all this! I have the feeling of having
> done exactly what Guennadi and Olof had asked me to do: What I get at
> the end: people having a bad feeling about my work, not expected merge
> conflicts which annoy everybody (only for a ridiculous amount of code),
> my patches delayed and a comment saying that I cannot handle simple
> dependency...
> Nice result!

I'm sorry for accusing you, you are right. You did exactly what was
agreed on in the mail thread, I just reread the history.

My impression is that Guennadi simply didn't know what he was doing
when he sent you a patch based on a branch that was clearly not
stable.

> - Guennadi did not want to take SoC/board code in his tree
> => I had to take those lines of code through at91/arm-soc breaking the
>    patch series and allowing the introduction of an out-of-sync merge

This was probably the first mistake. It would have been trivial
to handle all this if we had just stuck the same commit into both
trees.

> I have understood and approved all the reasons for the requested
> changes, of course. But for which gain?
> 
> Ok... well, it looks like a massive incomprehension which took us time
> and ends up by wastefulness.

Agreed. How about if you rebase the few other (non-ISI) patches that
I had in arm-soc onto v3.2 and send me an updated pull request so
I can send them on? There's no reason to hold them up.

	Arnd
