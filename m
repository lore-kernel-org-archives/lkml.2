Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab1DDNWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 09:22:30 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:33421 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750934Ab1DDNW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:22:29 -0400
Date: Mon, 4 Apr 2011 15:22:26 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: pavel@ucw.cz, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org, marek.vasut@gmail.com,
        dmitry.torokhov@gmail.com
Subject: WARNING: at mm/page_alloc.c
Message-ID: <20110404132226.GA14806@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
I'm playing with uinput on zaurus (spitz) I've a pxa-2.6 kernel flashed in the
uinput is loaded as module. Right after my program called:

ioctl(fd, UI_DEV_CREATE);

I've got:

WARNING: at mm/page_alloc.c:2012 __alloc_pages_nodemask+0148/0x5a8()

and the ioctl() has failed.

Anybody has an idea what went wrong?
-- 
metan
