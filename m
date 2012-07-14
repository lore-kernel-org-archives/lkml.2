Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab2GNTAB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 15:00:01 -0400
Received: from void.printf.net ([89.145.121.20]:49376 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab2GNS7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 14:59:54 -0400
From: Chris Ball <cjb@laptop.org>
To: Maya Erez <merez@codeaurora.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH RESEND v4 1/2] mmc: card: Move MMC specific attributes to mmc sub-directory
References: <1342291613-3189-2-git-send-email-merez@codeaurora.org>
Date: Sat, 14 Jul 2012 14:59:48 -0400
In-Reply-To: <1342291613-3189-2-git-send-email-merez@codeaurora.org> (Maya
	Erez's message of "Sat, 14 Jul 2012 21:46:52 +0300")
Message-ID: <87a9z2kw2j.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 14 2012, Maya Erez wrote:
> Separate MMC specific attributes from general block device
> attributes and move them from the /sys/block/<BLOCK_DEV> directory
> to /sys/block/<BLOCK_DEV>/mmc directory

I don't think we can do this, even though the change is a good one.
What happens if someone has userspace scripts that manipulate force_ro,
or ro_lock_until_next_power_on?

sysfs isn't a firmly stable kernel ABI, but I think it's much closer
to one than this patch implies.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
