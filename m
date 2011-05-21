Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab1EUO2D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 10:28:03 -0400
Received: from ns.penguin.cz ([84.21.108.25]:38640 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab1EUO2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 10:28:01 -0400
Subject: Re: Disable CF during suspend
From: Stanislav Brabec <utx@penguin.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        zaurus-devel@www.linuxtogo.org, Marek Vasut <marek.vasut@gmail.com>
In-Reply-To: <20110521094326.GB26323@elf.ucw.cz>
References: <20110521094326.GB26323@elf.ucw.cz>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Sat, 21 May 2011 16:27:58 +0200
Message-ID: <1305988078.5824.14.camel@utx.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Disable SPITZ_SCP_CF_POWER during suspend. Otherwise it eats battery,
> fast. Thanks to Stanislav Brabec.

If you can verify that your card turns off on suspend, then you have my:
Acked-by: Stanislav Brabec <utx@penguin.cz>

But I would line to see more aggressive power control, something like
spitz_card_pwr_ctrl() in old kernels - if there is no CF and no
(external) CF card inserted, then SPITZ_SCP_CF_POWER card be turned off.
If they are memory cards, they can be turned off even while idle.

-- 

________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx, ICQ 116020046, xmpp:utx@jabber.cz

