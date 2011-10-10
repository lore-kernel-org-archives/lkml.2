Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab1JJHzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 03:55:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:61267 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab1JJHzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 03:55:45 -0400
Date: Mon, 10 Oct 2011 10:52:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Pelle Windestam <pelle@windestam.se>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers: staging: rts_pstor fixed checkpatch warnings
Message-ID: <20111010075250.GY18470@longonot.mountain>
References: <1318225337-25438-1-git-send-email-pelle@windestam.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318225337-25438-1-git-send-email-pelle@windestam.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4E92A4FD.0201:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 07:42:17AM +0200, Pelle Windestam wrote:
> -static struct pci_device_id rtsx_ids[] = {
> -	{ 0x10EC, 0x5208, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_OTHERS << 16, 0xFF0000 },
> -	{ 0x10EC, 0x5209, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_OTHERS << 16, 0xFF0000 },
> -	{ 0x10EC, 0x5288, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_OTHERS << 16, 0xFF0000 },
> +static DEFINE_PCI_DEVICE_TABLE(rtsx_ids) = {
> +	{ 0x10EC, 0x5208, PCI_ANY_ID, PCI_ANY_ID,
> +	  PCI_CLASS_OTHERS << 16, 0xFF0000 },
> +	{ 0x10EC, 0x5209, PCI_ANY_ID, PCI_ANY_ID,
> +	  PCI_CLASS_OTHERS << 16, 0xFF0000 },
> +	{ 0x10EC, 0x5288, PCI_ANY_ID, PCI_ANY_ID,
> +	  PCI_CLASS_OTHERS << 16, 0xFF0000 },
>  	{ 0, },
>  };

This looked nicer in the original version.  I know that checkpatch
complains but in the end, checkpatch is just a perl script.  It's
less sentient than a squirrel.

regards,
dan carpenter
