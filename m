Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab0LQQSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 11:18:36 -0500
Received: from ausxippc101.us.dell.com ([143.166.85.207]:54877 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab0LQQSf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 11:18:35 -0500
X-Loopcount0: from 10.170.28.39
From: <Narendra_K@Dell.com>
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: <Matt_Domsch@Dell.com>, <Jordan_Hargrave@Dell.com>,
        <Charles_Rose@Dell.com>
Date: Fri, 17 Dec 2010 08:17:29 -0800
Subject: Re: [PATCH] Enable pci=bfsort by default on future Dell systems
Thread-Topic: [PATCH] Enable pci=bfsort by default on future Dell systems
Thread-Index: AcueBeb13z1+0/pnT+qvDUBtsK0noQ==
Message-ID: <20101217161102.GA32069@fedora-14-r710.oslab.blr.amer.dell.com>
References: <20101214175048.GC31345@fedora-14-r710.oslab.blr.amer.dell.com>
In-Reply-To: <20101214175048.GC31345@fedora-14-r710.oslab.blr.amer.dell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.5.21 (2010-09-15)
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 11:21:19PM +0530, K, Narendra wrote:
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

Hello Jesse,

Please let us know if there are any concerns with this patch. If the
patch is acceptable, please consider it for inclusion.

With regards,
Narendra K
