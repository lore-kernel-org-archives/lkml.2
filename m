Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab1EaPFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:05:16 -0400
Received: from void.printf.net ([89.145.121.20]:53086 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827Ab1EaPFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:05:14 -0400
From: Chris Ball <cjb@laptop.org>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, philipl@overt.org,
        w.sang@pengutronix.de
Subject: Re: [PATCH] mmc: Enable MMC card reader for RICOH [1180:e823]
References: <1306426745-3636-1-git-send-email-manoj.iyer@canonical.com>
	<1306426745-3636-2-git-send-email-manoj.iyer@canonical.com>
	<m3fwo0u9sf.fsf@pullcord.laptop.org>
	<alpine.DEB.2.02.1105310958460.4067@sleepy>
Date: Tue, 31 May 2011 11:05:55 -0400
In-Reply-To: <alpine.DEB.2.02.1105310958460.4067@sleepy> (Manoj Iyer's message
	of "Tue, 31 May 2011 10:01:00 -0500 (CDT)")
Message-ID: <m3d3iyoqp8.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 31 2011, Manoj Iyer wrote:
>> Do you not need a corresponding entry in drivers/mmc/host/sdhci-pci.c's
>> pci_device_id struct?
>
> I believe there is an entry there already, introduced by this patch:
> https://lkml.org/lkml/2011/2/11/309

I see, thanks; patch is queued for 3.0 with a stable@ tag.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
