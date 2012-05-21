Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab2EUVbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:31:43 -0400
Received: from mout2.fh-giessen.de ([212.201.18.46]:50560 "EHLO
	mout2.fh-giessen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab2EUVbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:31:42 -0400
Message-ID: <4FBAB439.3040104@mni.thm.de>
Date: Mon, 21 May 2012 23:31:37 +0200
From: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/15.0 Thunderbird/15.0a1
MIME-Version: 1.0
To: alex.buell@munted.eu
CC: Mailing Lists - Kernel Developers <linux-kernel@vger.kernel.org>
Subject: Re: 3.4: Build failure for lpfc_scsi driver
References: <1337635015.29025.41.camel@lithium.local.net>
In-Reply-To: <1337635015.29025.41.camel@lithium.local.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.05.2012 23:16, Alex Buell wrote:
> cc1: warnings being treated as errors
> drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_bpl’:
> drivers/scsi/lpfc/lpfc_scsi.c:1900:11: error: unused variable ‘rc’
> drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_bpl_prot’:
> drivers/scsi/lpfc/lpfc_scsi.c:2037:11: error: unused variable ‘rc’
> drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_sgl’:
> drivers/scsi/lpfc/lpfc_scsi.c:2256:11: error: unused variable ‘rc’
> drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_sgl_prot’:
> drivers/scsi/lpfc/lpfc_scsi.c:2386:11: error: unused variable ‘rc’
>
> Easily fixed though but all the other warnings previously seen were fine
> yet this module was compiled with warnings being treated as errors?
Had this reported already. The flag in the Makefile for this driver was 
introduced between v3.3 and v3.4-rc1, in earlier versions it was 
compiled without it. If you don't actually need it just remove the flag 
and it will compile just fine!

