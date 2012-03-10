Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab2CJMsF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 07:48:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34175 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab2CJMsB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 07:48:01 -0500
MIME-Version: 1.0
X-Originating-IP: [46.116.134.132]
In-Reply-To: <20120309190202.425318888@linuxfoundation.org>
References: <20120309194424.GA2134@kroah.com> <20120309190202.425318888@linuxfoundation.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 10 Mar 2012 14:47:41 +0200
Message-ID: <CAK=WgbZs-p=g6tXKNTOt2n8r4HHe-Td_iW3n2k5k2-mhZ6VkTg@mail.gmail.com>
Subject: Re: [ 01/95] ARM: OMAP: make iommu subsys_initcall to fix builtin omap3isp
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, James <angweiyang@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, Mar 9, 2012 at 9:02 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Ohad Ben-Cohen <ohad@wizery.com>
>
> commit 435792d93410f008120c4dbab148019a3cc31dbc upstream.

Can you please also take commit 134d12f "ARM: OMAP: fix iommu, not mailbox" ?

commit 435792d "ARM: OMAP: make iommu subsys_initcall to fix builtin
omap3isp" had a typo, which was fixed by 134d12f "ARM: OMAP: fix
iommu, not mailbox" (and the latter wasn't flagged for stable, sorry).

Thanks,
Ohad.
