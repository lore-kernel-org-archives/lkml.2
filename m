Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab1AGW1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:27:47 -0500
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:49926 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754533Ab1AGW1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:27:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=PtCR4wTD09shs8+p0kAzdtRz6NBJc0L2b3sDONouD7FnloNHCuiemHKNM6r5okYZvTL2meRVAvnbOuxZfKsaLFz8FCiiA3r2yg3ACdX/vuK4cBnhH/vUchhmCnFzdjzK;
Date: Fri, 7 Jan 2011 14:27:42 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: <Narendra_K@Dell.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <Matt_Domsch@Dell.com>, <Jordan_Hargrave@Dell.com>,
        <Charles_Rose@Dell.com>
Subject: Re: [PATCH] Enable pci=bfsort by default on future Dell systems
Message-ID: <20110107142742.0b1bcfaa@jbarnes-desktop>
In-Reply-To: <20101214175048.GC31345@fedora-14-r710.oslab.blr.amer.dell.com>
References: <20101214175048.GC31345@fedora-14-r710.oslab.blr.amer.dell.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010 09:57:12 -0800
<Narendra_K@Dell.com> wrote:

> Hello,
> 
> This patch enables pci=bfsort by default on future Dell systems.
> Please consider for inclusion if acceptable.
> 
> From: Jordan Hargrave <jordan_hargrave@dell.com>
> Subject: [PATCH] Enable pci=bfsort by default on future Dell systems
> 
> This patch enables pci=bfsort by default on future Dell systems.
> It reads SMBIOS type 0xB1 vendor specific record and sets pci=bfsort accordingly.
> 
> Offset  Name    Length  Value   Description
> 
> 04      Flags0  Word    Varies  Bits 9-10
>                                 - 10:9 = 00  Unknown
>                                 - 10:9 = 01  Breadth First
>                                 - 10:9 = 10  Depth First
>                                 - 10:9 = 11  Reserved
> 
> 1. Any time pci=bfsort has to be enabled on a system, we need to add the model
> number of the system to the white list. With this patch, that is not required.
> 
> 2. Typically, model number has to be added to the white list when the system is
> under development. With this change, that is not required.
> 
> Signed-off-by: Jordan Hargrave <jordan_hargrave@dell.com>
> Signed-off-by: Narendra K <narendra_k@dell.com>
> ---

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
