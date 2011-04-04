Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1DDWGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:06:25 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38985 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753856Ab1DDWGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:06:24 -0400
Date: Tue, 5 Apr 2011 00:06:22 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org, marek.vasut@gmail.com
Subject: Re: WARNING: at mm/page_alloc.c
Message-ID: <20110404220622.GA11677@atrey.karlin.mff.cuni.cz>
References: <20110404132226.GA14806@atrey.karlin.mff.cuni.cz> <20110404212906.GA984@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110404212906.GA984@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> Maybe if you could post your program we could see what exactly went
> wrong...

Gone trought my code once again and found small typo in sizeof() in
uinput_user_dev initialization.

Sorry for the noise.

-- 
metan
