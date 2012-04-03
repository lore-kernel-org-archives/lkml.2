Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2DCBig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 21:38:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab2DCBif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 21:38:35 -0400
Date: Tue, 3 Apr 2012 03:38:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>, linux-kernel@vger.kernel.org,
        GregKH <greg@kroah.com>
Subject: Re: [PATCH] w1: fix slave driver registration error message
In-Reply-To: <20120402095626.GA27407@ioremap.net>
Message-ID: <alpine.LNX.2.00.1204030338190.16928@pobox.suse.cz>
References: <1333345342-12113-1-git-send-email-mad_soft@inbox.ru> <20120402095626.GA27407@ioremap.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2012, Evgeniy Polyakov wrote:

> > W1 core prints "Failed to register master driver" if error happens
> > on registering SLAVE driver. Fix it.
> > 
> > Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> 
> Patch looks good, thank you
> Greg, please pull it into your tree if Jiri will not pick it into
> trivial@

I have now picked it up. Thanks,

-- 
Jiri Kosina
SUSE Labs
