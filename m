Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab0GTP1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:27:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:34426 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab0GTP1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:27:36 -0400
Date: Tue, 20 Jul 2010 17:27:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Christoph Egger <siccegge@cs.fau.de>,
        Russell King <linux@arm.linux.org.uk>, Daniel Mack <daniel@caiaq.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 31/33] Removing dead MACH_U300_BS26
In-Reply-To: <AANLkTikyk4fu72kWFfxQyEV_GHTc5flLYytF9cnHDBE_@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1007201727160.4741@pobox.suse.cz>
References: <cover.1277911345.git.siccegge@cs.fau.de> <2a81bf5506ce15ac839ca4fa58dc8af4112ff531.1277911346.git.siccegge@cs.fau.de> <AANLkTikyk4fu72kWFfxQyEV_GHTc5flLYytF9cnHDBE_@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010, Linus Walleij wrote:

> > MACH_U300_BS26 doesn't exist in Kconfig, therefore removing all
> > references for it from the source code.
> >
> > Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> 
> OK then,
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>

As this doesn't seem to be present in linux-next as of today, I have 
applied it to trivial queue. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
