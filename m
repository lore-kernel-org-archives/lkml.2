Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab1DLPwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:52:21 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:42084 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757979Ab1DLPwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:52:18 -0400
Date: Tue, 12 Apr 2011 17:52:17 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, utx@penguin.cz,
        zaurus-devel@www.linuxtogo.org, marek.vasut@gmail.com
Subject: Re: zaurus: mmcblk0: error -110
Message-ID: <20110412155217.GA982@atrey.karlin.mff.cuni.cz>
References: <20110412151547.GC20815@atrey.karlin.mff.cuni.cz> <BANLkTikNEJEwq4cfr6cmTcHqcRfyGLM6Ww@mail.gmail.com> <20110412152307.GD20815@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412152307.GD20815@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > Which model do you have? And check the corresponding board file if
> > card detect GPIO handling is doing right.
> 
> I've got spitz (SL-3200).
> 
> So I suppose the board file is arch/arm/mach-pxa/spitz.c, I'll have a look.

Hmm, besides cleanup by Marek Vasut there were no changes in the code. And it
seems that it was just cleanup in spitz_card_pwr_ctrl().

-- 
metan
