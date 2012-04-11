Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab2DKQ65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:58:57 -0400
Received: from void.printf.net ([89.145.121.20]:35916 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab2DKQ64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:58:56 -0400
From: Chris Ball <cjb@laptop.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] mmc: remove linux/blkdev.h include from host drivers
References: <1334084783-3572-1-git-send-email-mad_soft@inbox.ru>
	<87ty0qs2fz.fsf@laptop.org> <20120411165223.GP3852@pengutronix.de>
Date: Wed, 11 Apr 2012 12:58:58 -0400
In-Reply-To: <20120411165223.GP3852@pengutronix.de> (Sascha Hauer's message of
	"Wed, 11 Apr 2012 18:52:23 +0200")
Message-ID: <87pqberyr1.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 11 2012, Sascha Hauer wrote:
>> Should imxmmc simply be removed from drivers/mmc/host?  Do any of the
>> more current i.MX MMC drivers support the same hardware?
>
> It has long been on my todo list to remove this driver. The more recent
> i.MX use the mxcmmc driver which is basically the same hardware but
> without a bunch of bugs which made the older imxmmc driver unusable on
> newer hardware. I can send a patch if you like.

Thanks, let's do it.

It would be nice to have a story for how MX1 users can use their
hardware with modern kernels, even if it's just "It should be possible
to modify the mxcmmc driver to support this older hardware, and the sort
of changes that need to be made are <..>".

(Dmitry, your patch is fine -- I can remove the imxmmc hunk from it when
applying.)

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
