Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0ESPqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:46:24 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:53292 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751565Ab0ESPqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:46:20 -0400
Date: Wed, 19 May 2010 17:46:18 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: pave@ucw.cz, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Subject: usb gadget on zaurus and kexec
Message-ID: <20100519154618.GA26381@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
After some testing I found out that no usb gadget (g_ether, g_mass_storage, ...)
is working after zaurus boots with kexec. So it seems like some missing
initalization (it's working after doing reboot again) anybody has any clue,
patch or ideas how to debug this?

-- 
Cyril Hrubis

