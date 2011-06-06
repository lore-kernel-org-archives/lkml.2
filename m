Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1FFLVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:21:35 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:54628 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753104Ab1FFLVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:21:34 -0400
Date: Mon, 6 Jun 2011 13:21:32 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>
Subject: Re: 3.0-rc1: alsactl restore fails on spitz
Message-ID: <20110606112132.GA16715@atrey.karlin.mff.cuni.cz>
References: <20110602031455.GC1565@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602031455.GC1565@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi! 
> Something changed in ALSA land, if you use sound you may want to check.

I've seen the errors on alsactl restore too. However sound seems to work for
me. Probably ALSA changed some ids of the knobs for alsamixer and the saved
state could not be properly restored.

-- 
metan
