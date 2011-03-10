Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1CJSAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 13:00:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab1CJSAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 13:00:20 -0500
Date: Thu, 10 Mar 2011 19:00:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Do not create input devices for feature reports
In-Reply-To: <20110310161635.GA23223@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1103101859070.19969@pobox.suse.cz>
References: <1298572259-18173-1-git-send-email-rydberg@euromail.se> <alpine.LNX.2.00.1103011702240.32580@pobox.suse.cz> <AANLkTikd67q_j_ySam7RZvau8WoESLEmdXkfCWerVrLp@mail.gmail.com> <alpine.LNX.2.00.1103011726300.32580@pobox.suse.cz>
 <20110310161635.GA23223@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011, Henrik Rydberg wrote:

> > > Tested-by: Benjamin Tissoires <benjmain.tissoires@gmail.com>
> > > Acked-by: Benjamin Tissoires <benjmain.tissoires@gmail.com>
> > 
> > Applied, thanks.
> 
> Hi Jiri,
> 
> I was wondering if this patch will appear in the final 2.6.38? It
> seems the regression it fixes is pretty severe for ntrig devices, and
> once out there, the callback argument change will create problems for
> add-on modules such as dkms modules.

Hi Henrik,

I am not sure Linus will be taking it for .38 still, as he is now offline 
and will be releasing final .38 after he appears, so it's unlikely that 
he'll take pull requests unless it's something super-severe.

I'll put it on my list of commits to be pushed out to 38-stable right 
away. Does that make sense?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
