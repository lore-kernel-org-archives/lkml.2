Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1ELBeC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 21:34:02 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:12677
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756467Ab1ELBeA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 21:34:00 -0400
X-SpamScore: -22
X-BigFish: VS-22(zz9371O4015L542M1432Nzz1202hzz8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Hu Mingkai-B21284 <B21284@freescale.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>
Subject: RE: spi_fsl_spi broken when compiled as module by
 b36ece832512c1a0afa54ff0a56d63492a1caf08
Thread-Topic: spi_fsl_spi broken when compiled as module by
 b36ece832512c1a0afa54ff0a56d63492a1caf08
Thread-Index: AQHMD/NmlBRc3temmEW7N4NnUhxzZZSIaR3w
Date: Thu, 12 May 2011 01:33:55 +0000
Message-ID: <9389EE59E16E9447AFB481039183BCF4117B10@039-SN1MPN1-005.039d.mgd.msft.net>
References: <20110511155211.GA21349@caffeine.csclub.uwaterloo.ca>
In-Reply-To: <20110511155211.GA21349@caffeine.csclub.uwaterloo.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

Please submit a patch to modify it.

Thanks,
Mingkai

> -----Original Message-----
> From: Lennart Sorensen [mailto:lsorense@csclub.uwaterloo.ca]
> Sent: Wednesday, May 11, 2011 11:52 PM
> To: linux-kernel@vger.kernel.org
> Cc: Hu Mingkai-B21284; Len Sorensen; Grant Likely
> Subject: spi_fsl_spi broken when compiled as module by
> b36ece832512c1a0afa54ff0a56d63492a1caf08
> 
> When code was refactored, spi_fsl_spi now depends on funfcionts in spi-
> fsl_lib, but those are not exported symbols so when building as a module
> the symbols are missing and the compile fails.
> 
> Adding these to spi_fsl_lib.c fixes the compile.
> 
> EXPORT_SYMBOL(mpc8xxx_spi_tx_buf_u32);
> EXPORT_SYMBOL(mpc8xxx_spi_rx_buf_u32);
> EXPORT_SYMBOL(mpc8xxx_spi_tx_buf_u16);
> EXPORT_SYMBOL(mpc8xxx_spi_rx_buf_u16);
> EXPORT_SYMBOL(mpc8xxx_spi_tx_buf_u8);
> EXPORT_SYMBOL(mpc8xxx_spi_rx_buf_u8);
> EXPORT_SYMBOL(mpc8xxx_spi_strmode);
> EXPORT_SYMBOL(mpc8xxx_spi_probe);
> EXPORT_SYMBOL(of_mpc8xxx_spi_probe);
> EXPORT_SYMBOL(mpc8xxx_spi_remove);
> EXPORT_SYMBOL(to_of_pinfo);
> 
> All releases since the refactoring was done would be affected.
> 
> --
> Len Sorensen


