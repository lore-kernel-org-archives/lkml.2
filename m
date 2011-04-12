Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab1DLPXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:23:15 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41328 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757196Ab1DLPXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:23:08 -0400
Date: Tue, 12 Apr 2011 17:23:07 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, utx@penguin.cz,
        zaurus-devel@www.linuxtogo.org, marek.vasut@gmail.com
Subject: Re: zaurus: mmcblk0: error -110
Message-ID: <20110412152307.GD20815@atrey.karlin.mff.cuni.cz>
References: <20110412151547.GC20815@atrey.karlin.mff.cuni.cz> <BANLkTikNEJEwq4cfr6cmTcHqcRfyGLM6Ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikNEJEwq4cfr6cmTcHqcRfyGLM6Ww@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> Which model do you have? And check the corresponding board file if
> card detect GPIO handling is doing right.

I've got spitz (SL-3200).

So I suppose the board file is arch/arm/mach-pxa/spitz.c, I'll have a look.

-- 
metan
