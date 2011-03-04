Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583Ab1CDM4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 07:56:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64630 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759397Ab1CDM4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 07:56:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 16/17] unicore32: add (void __iomem *) to io_p2v macro
Date: Fri, 4 Mar 2011 12:52:57 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "'Guan Xuetao'" <epip@hera.kernel.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com
References: <cover.1298821856.git.epip@hera.kernel.org> <201102281635.56528.arnd@arndb.de> <03ba01cbda54$a5c39f00$f14add00$@mprc.pku.edu.cn>
In-Reply-To: <03ba01cbda54$a5c39f00$f14add00$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103041252.57410.arnd@arndb.de>
X-Provags-ID: V02:K0:8x5Z9Ar3R/KM730cn7C4NW+ArbDWXfrQeYh5za7fSF6
 S9VLg89uFFfOuO74daH5YEh0O5rizX1Z6k7sFecqfsZdHWUHcF
 NQ3NqVIL8kjpFkhjDNAbRbJq43+2+XYy/tMCfH19FjQgyvJvzV
 UQlY2tXBVo9LhjkuBVZmGvT5+2GPNsJzMZ26NxSBRzGqaixM6P
 VxHlqmlRMuW4UJKtBBWyw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 March 2011, Guan Xuetao wrote:
> From: GuanXuetao <gxt@mprc.pku.edu.cn>
> Date: Fri, 4 Mar 2011 18:07:48 +0800
> Subject: [PATCH] unicore32: modify io_p2v and io_v2p macros, and adjust PKUNITY_mmio_BASEs
> 
> 1. remove __REG macro
> 2. add (void __iomem *) to io_p2v macro
> 3. add (phys_addr_t) to io_v2p macro
> 4. add PKUNITY_AHB_BASE and PKUNITY_APB_BASE definitions
> 5. modify all PKUNITY_mmio_BASEs from physical addr to virtual addr
> 6. adjust prefix macro for all usage of PKUNITY_mmio_BASEs
>   -- by advice with Arnd Bergmann
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Looks good,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

