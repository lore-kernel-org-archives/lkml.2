Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab0IUOQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:16:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:57622 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab0IUOQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:16:00 -0400
Date: Tue, 21 Sep 2010 16:15:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: 3m: Output proper orientation range
In-Reply-To: <20100919232343.GA6565@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1009211615500.26813@pobox.suse.cz>
References: <1284886583-30965-1-git-send-email-rydberg@euromail.se> <20100919232343.GA6565@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Sep 2010, Dmitry Torokhov wrote:

> > The range of orientation values for height/width devices should
> > be [0, 1], but is currently set to [1, 1]. Having min == max also
> > breaks uinput device setup. Fixed with this patch.
> > 
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> 
> Makes sense.
> 
> Acked-by: Dmitry Torokhov <dtor@mail.ru>

Applied, thank you.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
