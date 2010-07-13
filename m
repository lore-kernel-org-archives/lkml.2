Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab0GMQcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 12:32:20 -0400
Received: from mail.perches.com ([173.55.12.10]:1858 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab0GMQcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 12:32:19 -0400
Subject: Re: [PATCH] Staging: comedi: Cleanup style issues in adl_pci9111.c
From: Joe Perches <joe@perches.com>
To: Mark <reodge@gmail.com>
Cc: gregkh@suse.de, Arun Thomas <arun.thomas@gmail.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Rich Folsom <rich.folsom@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1279038257-18055-1-git-send-email-reodge@gmail.com>
References: <1279038257-18055-1-git-send-email-reodge@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jul 2010 09:32:16 -0700
Message-ID: <1279038736.1501.412.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-13 at 17:24 +0100, Mark wrote:
>  static DEFINE_PCI_DEVICE_TABLE(pci9111_pci_table) = {
> -	{
> -	PCI_VENDOR_ID_ADLINK, PCI9111_HR_DEVICE_ID, PCI_ANY_ID,
> -		    PCI_ANY_ID, 0, 0, 0},
> -	    /* { PCI_VENDOR_ID_ADLINK, PCI9111_HG_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, */
> -	{
> -	0}
> +	{ PCI_VENDOR_ID_ADLINK, PCI9111_HR_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,
> +	  0, 0, 0 },
> +	/* { PCI_VENDOR_ID_ADLINK, PCI9111_HG_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,
> +	 *   0, 0, 0 }, */
> +	{ 0 }
>  };

PCI_VDEVICE()


