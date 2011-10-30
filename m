Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab1J3Aln (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 20:41:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51454 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648Ab1J3Alm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 20:41:42 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-mtd@lists.infradead.org
Subject: Re: [PATCH 00/13]  DocG3 fixes and write support
Date: Sun, 30 Oct 2011 02:41:39 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Robert Jarzmik <robert.jarzmik@free.fr>, dwmw2@infradead.org,
        dedekind1@gmail.com, mikedunn@newsguy.com,
        linux-kernel@vger.kernel.org
References: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110300241.39534.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patchset is aimed at :
>  - fixing 4 glitches in the driver
>  - add several new functions
> 
> The added functions are :
>  - add block erase capability
>  - add write page capability
>  - add powerdown and powerup
>  - add multiple floor support
>  - add ECC support
> 
> The ECC part should especially be reviewed by Ivan and Mike,
> as this is their work (patch "add ECC correction code").
> 
> Happy review.
> 
> --
> Robert
> 
> Robert Jarzmik (13):
>   mtd/docg3: fix debug log verbosity
>   mtd/docg3: fix tracing of IO in writeb
>   mtd/docg3: fix protection areas reading
>   mtd/docg3: fix BCH registers
>   mtd/docg3: add multiple floor support
>   mtd/docg3: add OOB layout to mtdinfo
>   mtd/docg3: add registers for erasing and writing
>   mtd/docg3: add OOB buffer to device structure
>   mtd/docg3: add write functions
>   mtd/docg3: add erase functions
>   mtd/docg3: map erase and write functions
>   mtd/docg3: add ECC correction code
>   mtd/docg3: add suspend and resume
> 
>  drivers/mtd/devices/Kconfig |    1 +
>  drivers/mtd/devices/docg3.c |  933
> +++++++++++++++++++++++++++++++++++++------ drivers/mtd/devices/docg3.h | 
>  42 ++-
>  3 files changed, 860 insertions(+), 116 deletions(-)

Hi,

can you sum up the situation about the another (docg4) driver for us not 
watching this too tightly? Was there any improvement/progress/... ?

Cheers
