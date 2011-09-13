Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab1IMNWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 09:22:55 -0400
Received: from void.printf.net ([89.145.121.20]:34908 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab1IMNWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 09:22:54 -0400
From: Chris Ball <cjb@laptop.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-mmc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SDHCI regression since 2.6.39
References: <4E6EA3E4.5080401@goop.org>
Date: Tue, 13 Sep 2011 09:22:41 -0400
In-Reply-To: <4E6EA3E4.5080401@goop.org> (Jeremy Fitzhardinge's message of
	"Mon, 12 Sep 2011 17:29:24 -0700")
Message-ID: <m2bouo37by.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

On Mon, Sep 12 2011, Jeremy Fitzhardinge wrote:
> Since 2.6.39, the SD card slot in my Lenovo X220 has stopped working.  
> When I insert a card with current linux.git kernel (3.1-rc6), I get:
>
> [ 3891.745549] mmc0: new SDHC card at address b368
> [ 3891.790704] mmcblk0: mmc0:b368 PNY   7.51 GiB 
> [ 3891.795568] mmc0: Got data interrupt 0x00200000 even though no data
> operation was in progress.

Please could you try reverting a3c7778f8153b9 "mmc: sdhci: R1B command
handling + MMC_CAP_ERASE"?  We've had one other similar report that
bisected to this patch.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
