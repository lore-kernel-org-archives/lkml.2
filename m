Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0HXNVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:21:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058Ab0HXNVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:21:32 -0400
Date: Tue, 24 Aug 2010 15:21:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Niels de Vos <ndevos@redhat.com>
Cc: linux-kernel@vger.kernel.org, Joe Krahn <krahn@niehs.nih.gov>
Subject: Re: [PATCH] parport_pc: show the detection of a 2 serial port ITE8874
 chip
In-Reply-To: <4C729FE4.5@redhat.com>
Message-ID: <alpine.LNX.2.00.1008241521200.1019@pobox.suse.cz>
References: <4C729FE4.5@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010, Niels de Vos wrote:

> The printk message for the 2 serial port version is obscured with a debug
> macro, unlike all other versions of the card. It should be changed to make
> the output equal for all detected models.
> 
> Reference: https://bugzilla.redhat.com/show_bug.cgi?id=578616#c1
> 
> CC: Joe Krahn <krahn@niehs.nih.gov>
> Signed-off-by: Niels de Vos <ndevos@redhat.com>
> ---
>  drivers/parport/parport_pc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
> index 0950fa4..8d62fb7 100644
> --- a/drivers/parport/parport_pc.c
> +++ b/drivers/parport/parport_pc.c
> @@ -2599,7 +2599,7 @@ static int __devinit sio_ite_8872_probe(struct pci_dev *pdev, int autoirq,
>  		printk(KERN_INFO "parport_pc: ITE8873 found (1S)\n");
>  		return 0;
>  	case 0x8:
> -		DPRINTK(KERN_DEBUG "parport_pc: ITE8874 found (2S)\n");
> +		printk(KERN_INFO "parport_pc: ITE8874 found (2S)\n");
>  		return 0;
>  	default:
>  		printk(KERN_INFO "parport_pc: unknown ITE887x\n");

Applied, thank you.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
