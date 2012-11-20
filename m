Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2KTDJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 22:09:15 -0500
Received: from void.printf.net ([89.145.121.20]:56836 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869Ab2KTDJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 22:09:13 -0500
From: Chris Ball <cjb@laptop.org>
To: wwang <wei_wang@realsil.com.cn>
Cc: "sameo\@linux.intel.com" <sameo@linux.intel.com>,
        "devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd\@arndb.de" <arnd@arndb.de>, "oakad\@yahoo.com" <oakad@yahoo.com>,
        "bp\@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v2 1/2] mmc/host/rtsx: Configure SD_CFG2 register in sd_rw_multi
References: <cover.1353377266.git.wei_wang@realsil.com.cn>
	<00fb063304a0720f3ba9db6f79bb67263d450356.1353377266.git.wei_wang@realsil.com.cn>
	<87ip91f1zo.fsf@octavius.laptop.org> <50AAED8E.4030201@realsil.com.cn>
Date: Mon, 19 Nov 2012 22:09:01 -0500
In-Reply-To: <50AAED8E.4030201@realsil.com.cn> (wwang's message of "Tue, 20
	Nov 2012 10:40:14 +0800")
Message-ID: <87ehjpezsi.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Nov 19 2012, wwang wrote:
> It's about compatibility issue. The default value of SD_CFG2 is proper
> for writing data. But for reading sequence, the timing is not good
> enough. So in some extreme circumstance,  card reader may sample the
> response data from the card as good even if the data is wrong. And
> this will cause the bad consequence.
>
> Shall I modify the commit and resend the patchset again?

Thanks!  Yes, please resend.

I won't be merging this one because Samuel is merging the initial
patchset, but I'll merge patches for the MMC side after 3.8.  For these:

Acked-by: Chris Ball <cjb@laptop.org>

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
