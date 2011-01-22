Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab1AVCRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 21:17:53 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:57659 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab1AVCRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 21:17:51 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'Jesse Barnes'" <jbarnes@virtuousgeek.org>
Cc: <sfr@canb.auug.org.au>, "'Arnd Bergmann'" <arnd@arndb.de>,
        <gregkh@suse.de>, <dmitry.torokhov@gmail.com>, <dtor@mail.ru>,
        <rubini@cvml.unipv.it>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-next@vger.kernel.org>
References: <004901cbb4d5$b9bb1370$2d313a50$@mprc.pku.edu.cn> <20110120114216.4b23182a@jbarnes-desktop>
In-Reply-To: <20110120114216.4b23182a@jbarnes-desktop>
Subject: RE: Request for unicore32 architecture codes to merge into linux-next
Date: Sat, 22 Jan 2011 10:17:16 +0800
Message-ID: <013801cbb9da$7f9bff10$7ed3fd30$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
thread-index: AQKvmpDs5qji3UzzcGj9LCTNHzRliwIJIVPXkgQ1BaA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jesse Barnes [mailto:jbarnes@virtuousgeek.org]
> Sent: Friday, January 21, 2011 3:42 AM
> To: Guan Xuetao
> Cc: sfr@canb.auug.org.au; Arnd Bergmann; gregkh@suse.de; dmitry.torokhov@gmail.com; dtor@mail.ru; rubini@cvml.unipv.it; linux-
> arch@vger.kernel.org; linux-kernel@vger.kernel.org; linux-fbdev@vger.kernel.org; linux-next@vger.kernel.org
> Subject: Re: Request for unicore32 architecture codes to merge into linux-next
> 
> On Sun, 16 Jan 2011 01:00:31 +0800
> "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn> wrote:
> 
> > Hi,
> >
> > I want to merge unicore32 repo into linux-next tree, the position is (unicore32 branch):
> >   git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git
> >
> > Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> > ---
> 
> Took a quick look at the PCI parts, looks like you have a pretty big
> DMA restriction.
Yes, only 128MB low memory could be used as dma space for pci devices.
> 
> You could provide your own dma map ops and make the allocator a bit
> smarter about where it gets memory (preferentially allocating from the
> DMA'able region, which you could hide).  Or do you find that swiotlb
> does ok in general?
Swiotlb works well. For almost all functions are provided by IPs inside the SoC,
the dma function is used mainly through amba/axi bus,  not pci bus.

> 
> Other than that you had pretty tiny bits of enabling code, I assume
> they work on your platform (config space access & setup, etc.).
Yes.
> 
> --
> Jesse Barnes, Intel Open Source Technology Center
Thanks Jesse

Guan Xuetao

