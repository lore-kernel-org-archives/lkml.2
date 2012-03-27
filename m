Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab2C0LRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 07:17:09 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:40120 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab2C0LRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 07:17:07 -0400
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGohdvpEkce+Ub40Q/uAFj+9EbzeXD+B2O8=
X-RZG-CLASS-ID: mo05
From: Stefan Roese <sr@denx.de>
To: "Thang Q. Nguyen" <tqnguyen@apm.com>
Subject: Re: [PATCH 1/1] Add support 2 SATA ports for Maui and change filename from sata_dwc_460ex.c to sata_dwc_4xx.c
Date: Tue, 27 Mar 2012 13:16:54 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-13-generic; KDE/4.7.2; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
References: <1332843983-24254-1-git-send-email-tqnguyen@apm.com>
In-Reply-To: <1332843983-24254-1-git-send-email-tqnguyen@apm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203271316.54562.sr@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 March 2012 12:26:23 Thang Q. Nguyen wrote:
> Support 2 native SATA ports on APM821XX and change the existing file name
> from sata_dwc_460ex.c to sata_dwc_4xx.c. This supports both 460EX and
> APM821XX.
> 
> Signed-off-by: Thang Q. Nguyen <tqnguyen@apm.com>
> ---
>  arch/powerpc/boot/dts/bluestone.dts |   21 +
>  drivers/ata/Makefile                |    2 +-
>  drivers/ata/sata_dwc_4xx.c          | 2178 +++++++++++++++++++++++++++++++++++
>  3 files changed, 2200 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/ata/sata_dwc_4xx.c

Please use -M option (find-renames) while generating this patch to see
changes in the driver. And you missed to remove the "old" driver.

Thanks,
Stefan
