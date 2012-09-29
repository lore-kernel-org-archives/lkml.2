Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab2I2Nld (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 09:41:33 -0400
Received: from void.printf.net ([89.145.121.20]:57739 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248Ab2I2Nlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 09:41:32 -0400
From: Chris Ball <cjb@laptop.org>
To: Borislav Petkov <bp@alien8.de>
Cc: wei_wang@realsil.com.cn, gregkh@linuxfoundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Phil Turmel <philip@turmel.org>, sameo@linux.intel.com,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, arnd@arndb.de, oakad@yahoo.com
Subject: Re: [PATCH v6 0/3] Add modules to support realtek PCIE card reader
References: <cover.1347330871.git.wei_wang@realsil.com.cn>
	<50664814.30407@turmel.org> <20120929110730.GA27797@liondog.tnic>
Date: Sat, 29 Sep 2012 09:41:17 -0400
In-Reply-To: <20120929110730.GA27797@liondog.tnic> (Borislav Petkov's message
	of "Sat, 29 Sep 2012 13:07:30 +0200")
Message-ID: <87d315osjm.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Sep 29 2012, Borislav Petkov wrote:
> So, I think that this driver has seen a bunch of testing and reviewing
> and we might start considering upstreaming it. There are a bunch of
> laptops integrating those readers and maybe a single three-month-ish -rc
> period of testing wouldn't hurt before it appears upstream.
>
> Now, AFAICT, there is another driver in staging which supports the same
> or a subset of the cardreaders this driver does so I don't know what
> Realsil want to do with that. Wei?
> 
> And since this driver touches multiple drivers/{mfd,mmc,memstick}
> subdirs, maybe akpm would like to merge it? At least I haven't seen any
> other maintainers complaining about its design or wanting to take it so

I think you've missed the mails -- Alex Dubov has acked the memstick
portion, Samuel Ortiz has said he'll push the MFD driver for 3.7,
and I've pushed the MMC driver into mmc-next for 3.7.  So, I think
we should merge it.  I don't think we need akpm, since there are no
build-time dependencies involved.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
