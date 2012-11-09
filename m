Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab2KIPfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:35:04 -0500
Received: from void.printf.net ([89.145.121.20]:48607 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab2KIPfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:35:01 -0500
From: Chris Ball <cjb@laptop.org>
To: wwang <wei_wang@realsil.com.cn>
Cc: "sameo\@linux.intel.com" <sameo@linux.intel.com>,
        "devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd\@arndb.de" <arnd@arndb.de>, "oakad\@yahoo.com" <oakad@yahoo.com>,
        "bp\@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v7 0/3] Add modules to support realtek PCIE card reader
References: <cover.1351481260.git.wei_wang@realsil.com.cn>
	<508F4A88.8010207@realsil.com.cn> <87r4o56w1f.fsf@octavius.laptop.org>
	<509D1C25.9040909@realsil.com.cn>
Date: Fri, 09 Nov 2012 10:34:48 -0500
In-Reply-To: <509D1C25.9040909@realsil.com.cn> (wwang's message of "Fri, 9 Nov
	2012 23:07:17 +0800")
Message-ID: <87mwyqrdrb.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 09 2012, wwang wrote:
> I have noticed that the file rtsx_pci_sdmmc.c in your mmc-next branch
> is still v6 patch.  In v7 patch, this MMC part has also been modified
> to comply with my MFD portion.  So please update to this version.
>
> And one more question. Samuel have merged all of my patch set in his
> for-next branch, including the MMC part.  I don't know whether this
> will conflict with your tree in the next merge.
>
> Hi Samuel:
>
> Since the whole patch set has been merged in your for-next branch,
> does it mean that you will help to merge all of the three parts to
> linus's tree?

I've removed the patch from my tree to avoid conflicting with Samuel.
I'm happy to either have the MMC patch go through the MFD tree with:

Acked-by: Chris Ball <cjb@laptop.org>

or to merge the MMC side of v7 myself, whichever Samuel prefers.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
