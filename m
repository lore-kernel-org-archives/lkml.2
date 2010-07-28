Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab0G1MaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 08:30:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:46801 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166Ab0G1MaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 08:30:13 -0400
Message-ID: <4C5022CE.3030609@kernel.org>
Date: Wed, 28 Jul 2010 14:30:06 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Nils Radtke <lkml@Think-Future.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ata_port_flush_task, BUG: unable to handle kernel paging request
References: <20100725154816.GF31966@localhost> <4C4E9C3B.9070402@kernel.org> <20100727195034.GP31966@localhost>
In-Reply-To: <20100727195034.GP31966@localhost>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 28 Jul 2010 12:30:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/27/2010 09:50 PM, Nils Radtke wrote:
> # Which kernel version is this?  What was the configuration and what
> # were the system doing?  Can you please post lspci -nn output and boot
> # log?
> Linux host 2.6.33.1 #3 PREEMPT Wed Mar 31 13:22:30 CEST 2010 i686 GNU/Linux
> 
> config: Internal sata disk.
> 
> action: iirc it was during a suspend/resume cycle or just during
> normal operation.

How reproducible is the problem?  Was it an one time event or have you
experienced it multiple times?

> the boot log of this particular boot/uptime when it happened isn't
> available any more.  fastboot is enabled, hdparm, laptop-mode and
> smartd are enabled (std debian config)

Can you please attach boot log of the same kernel?  It doesn't have to
be from the same boot.

Thanks.

-- 
tejun
