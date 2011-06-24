Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1FXJTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 05:19:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51160 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab1FXJTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 05:19:41 -0400
Date: Fri, 24 Jun 2011 11:19:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Trivial next 1/2] treewide: Fix recieve/receive typos
In-Reply-To: <878fc4b8ba243033d5d325e2d1b6578dde8d0e87.1308853652.git.joe@perches.com>
Message-ID: <alpine.LNX.2.00.1106241119020.11049@pobox.suse.cz>
References: <cover.1308853652.git.joe@perches.com> <878fc4b8ba243033d5d325e2d1b6578dde8d0e87.1308853652.git.joe@perches.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011, Joe Perches wrote:

> Just spelling fixes.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/mmc/host/vub300.c     |    4 ++--
>  drivers/net/caif/caif_hsi.c   |    2 +-
>  drivers/net/wan/lmc/lmc_var.h |    2 +-
>  drivers/usb/misc/ftdi-elan.c  |   28 ++++++++++++++--------------
>  include/scsi/osd_initiator.h  |    2 +-
>  sound/soc/omap/ams-delta.c    |    2 +-

I have applied, with exception for drivers/net/caif/caif_hsi.c, as this is 
not in Linus' tree yet (which is what I base my tree on).
Could you please resend to davem?

Thanks,

-- 
Jiri Kosina
SUSE Labs
