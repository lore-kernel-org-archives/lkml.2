Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2FLNYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 09:24:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340Ab2FLNYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 09:24:35 -0400
Message-ID: <4FD7430B.6010005@redhat.com>
Date: Tue, 12 Jun 2012 10:24:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v2 0/3] EDAC support for Calxeda Highbank
References: <1339468334-9927-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1339468334-9927-1-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

Em 11-06-2012 23:32, Rob Herring escreveu:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> This series adds EDAC support for Calxeda Highbank platform L2 and
> memory ECC hardware.
> 
> This version is rebased current edac next tree for 3.6. Changes in
> this version are the addition of a common edac debugfs directory and
> coverting the highbank error injection to use debugfs.

Thanks for the patches.

It looks OK on my eyes, with regards to the EDAC API usage. While this patch
touches at the arm/devicetree stuff, most of the changes belong to EDAC, so
I'll apply them with my SOB on my tree.

Regards,
Mauro.
> 
> Rob
> 
> Rob Herring (3):
>    edac: create top-level debugfs directory
>    edac: add support for Calxeda highbank memory controller
>    edac: add support for Calxeda highbank L2 cache ecc
> 
>   .../devicetree/bindings/arm/calxeda/l2ecc.txt      |   17 ++
>   .../devicetree/bindings/arm/calxeda/mem-ctrlr.txt  |   17 ++
>   arch/arm/boot/dts/highbank.dts                     |   12 +
>   drivers/edac/Kconfig                               |   16 +-
>   drivers/edac/Makefile                              |    4 +
>   drivers/edac/edac_mc_sysfs.c                       |   23 +-
>   drivers/edac/edac_module.c                         |    3 +
>   drivers/edac/edac_module.h                         |   14 ++
>   drivers/edac/highbank_l2_edac.c                    |  149 ++++++++++++
>   drivers/edac/highbank_mc_edac.c                    |  256 ++++++++++++++++++++
>   10 files changed, 509 insertions(+), 2 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/arm/calxeda/l2ecc.txt
>   create mode 100644 Documentation/devicetree/bindings/arm/calxeda/mem-ctrlr.txt
>   create mode 100644 drivers/edac/highbank_l2_edac.c
>   create mode 100644 drivers/edac/highbank_mc_edac.c
> 


