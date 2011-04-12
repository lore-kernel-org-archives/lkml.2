Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab1DLS2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:28:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:37036 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291Ab1DLS2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:28:24 -0400
Date: Tue, 12 Apr 2011 20:28:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
cc: Marcel Holtmann <marcel@holtmann.org>,
        Vinicius Costa Gomes <vinicius.gomes@openbossa.org>,
        Keith Packard <keithp@keithp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.39-rc2 regression: X201s fails to resume
 b77dcf8460ae57d4eb9fd3633eb4f97b8fb20716
In-Reply-To: <20110412180933.GA2836@joana>
Message-ID: <alpine.LFD.2.00.1104122027180.4086@localhost6.localdomain6>
References: <yun1v1fj024.fsf@aiko.keithp.com> <alpine.LFD.2.00.1104070022280.3971@localhost6.localdomain6> <alpine.LFD.2.00.1104082340020.2724@localhost6.localdomain6> <yunaag0tjzb.fsf@aiko.keithp.com> <20110409000857.GB25581@piper>
 <alpine.LFD.2.00.1104111807480.4501@localhost6.localdomain6> <1302558033.2572.219.camel@aeonflux> <alpine.LFD.2.00.1104120014130.2702@localhost6.localdomain6> <alpine.LFD.2.00.1104120016490.2702@localhost6.localdomain6> <20110411222504.GE2195@joana>
 <20110412180933.GA2836@joana>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="353003779-1641821860-1302632899=:4086"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--353003779-1641821860-1302632899=:4086
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 12 Apr 2011, Gustavo F. Padovan wrote:
> * Gustavo F. Padovan <padovan@profusion.mobi> [2011-04-11 19:25:04 -0300]:
> > * Thomas Gleixner <tglx@linutronix.de> [2011-04-12 00:19:32 +0200]:
> > It is armed at each HCI command we send. In the close path we send out an HCI
> > RESET command that rearms it.
> 
> I applied v2 patch from Vinícius that fix all the symptoms. Now we have more time
> to find the real cause of this bug. However I still have no idea, I'm not able
> to reproduce it.

You might poke Ingo. He had a reproducer.

Thanks,

	tglx
--353003779-1641821860-1302632899=:4086--
