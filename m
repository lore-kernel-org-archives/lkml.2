Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab1C0NyH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 09:54:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39834 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1C0NyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 09:54:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DdIEMW2jIXQ6QjpWeIwMXV5Ke+0Wbbx5WvOcZPOU3kYPSrphRAr0AYvixcOkZA/SG1
         K0ELQEdvynthbNfv67qDYmrOM/gWqK9FbSMntQX4OqcL26paNofAA4nVKOzIh1mApw+U
         d3jVJaYt4ui0LtaGFIo+mwt0fe6otH5oxBdPc=
Date: Sun, 27 Mar 2011 15:53:59 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: wanlong.gao@gmail.com
Cc: greg@kroah.com, harryxiyou@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixed the format: lines over 80 characters .
Message-ID: <20110327125359.GA5816@p183.telecom.by>
References: <1301195244-4606-1-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301195244-4606-1-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 11:07:24AM +0800, wanlong.gao@gmail.com wrote:
>     Lines over 80 characters

>  static DEFINE_PCI_DEVICE_TABLE(cmodio_pci_ids) = {
> -	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9030, PCI_VENDOR_ID_JANZ, 0x0101 },
> -	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050, PCI_VENDOR_ID_JANZ, 0x0100 },
> +	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9030,
> +			PCI_VENDOR_ID_JANZ, 0x0101 },
> +	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
> +			PCI_VENDOR_ID_JANZ, 0x0100 },

NAK, this is less readable.
