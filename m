Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab0DNTgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 15:36:55 -0400
Received: from isilmar.linta.de ([213.133.102.198]:48105 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752428Ab0DNTgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 15:36:53 -0400
Date: Wed, 14 Apr 2010 21:23:02 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Timur Maximov <xcom.org@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] serial_cs: MD55x support (PCMCIA GPRS/EDGE modem)
 (kernel 2.6.33)
Message-ID: <20100414192302.GK30734@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Timur Maximov <xcom.org@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	greg@kroah.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414161947.18968240@lxorguk.ukuu.org.uk>
 <20100414190657.50a245f8.xcom.org@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 07:06:57PM +0400, Timur Maximov wrote:
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
...
> Acked-by: Alan Cox <alan@linux.intel.com>

Thanks, will pick this up in the PCMCIA git tree unless someone objects.

Best,
	Dominik
