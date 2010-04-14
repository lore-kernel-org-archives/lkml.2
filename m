Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0DNPP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:15:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60026 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755734Ab0DNPP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:15:26 -0400
Date: Wed, 14 Apr 2010 16:19:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Timur Maximov <xcom.org@gmail.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] serial_cs: MD55x support (PCMCIA GPRS/EDGE modem)
 (kernel 2.6.33)
Message-ID: <20100414161947.18968240@lxorguk.ukuu.org.uk>
In-Reply-To: <20100414190657.50a245f8.xcom.org@gmail.com>
References: <20100414190657.50a245f8.xcom.org@gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010 19:06:57 +0400
Timur Maximov <xcom.org@gmail.com> wrote:

> Many PCMCIA GPRS modems like: Onda Edge N100E, Novaway PC98 (OEM SPC98Z),
> Rovermate Edgus Adaptmate-039 and others have same construction and
> identification:
> 
> lspcmcia -vvv
> Product Name:   Generic Modem: MD55x 1.00 Serial number: xxxxx-xxx 
> Identification: manf_id: 0x015d card_id: 0x4c45
>                 function: 2 (serial)
>                 prod_id(1): "Generic" (0xc49e4731)
>                 prod_id(2): "Modem: MD55x" (0x8913b110)
>                 prod_id(3): "1.00" (0x83dbf271)
>                 prod_id(4): "Serial number: xxxxx-xxx" (0x73ee9514)
> 
> Serial connection to GSM module based on Elan VPU16551 PCMCIA UART with
> datasheet recommeded 14.7456MHz crystal oscillator.
> 
> By default serial_cs set UART clock == 1843200 Hz
> For correct work need set clock 14745600 Hz.
> This quirk already present in driver, only need add device in quirk list.
> 
> Signed-off-by: Timur Maximov <xcom.org@gmail.com>

Acked-by: Alan Cox <alan@linux.intel.com>
