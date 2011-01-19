Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab1ASBAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 20:00:43 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60886 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab1ASBAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 20:00:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Iu4nu2SsCYtZZ44nbmMae8LTKu8JKqYxS4w2H0UUuKNyOeYf2BEtLSaT1GpSYXFTUR
         tVB7EnO1aMc7OkPO+aZCaZ8kt37U5n2iQRNPtqga4opxaSFHiRd0G+UfIPUiTw6nz2O7
         dKTGFBbIPUasipFZmjVQSgggrTqZ4jrBJQyP4=
Message-ID: <4D3637B6.4040107@pobox.com>
Date: Tue, 18 Jan 2011 20:00:38 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Seth Heasley <seth.heasley@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.3.37] ahci: AHCI mode SATA patch for Intel DH89xxCC
 DeviceIDs
References: <201101101257.17449.seth.heasley@intel.com>
In-Reply-To: <201101101257.17449.seth.heasley@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2011 03:57 PM, Seth Heasley wrote:
> This patch adds the AHCI-mode SATA DeviceID for the Intel DH89xxCC PCH.
>
> Signed-off-by: Seth Heasley<seth.heasley@intel.com>
>
> --- linux-2.6.37/drivers/ata/ahci.c.orig	2011-01-04 16:50:19.000000000 -0800
> +++ linux-2.6.37/drivers/ata/ahci.c	2011-01-06 14:16:00.000000000 -0800
> @@ -260,6 +260,7 @@
>   	{ PCI_VDEVICE(INTEL, 0x1d02), board_ahci }, /* PBG AHCI */
>   	{ PCI_VDEVICE(INTEL, 0x1d04), board_ahci }, /* PBG RAID */
>   	{ PCI_VDEVICE(INTEL, 0x1d06), board_ahci }, /* PBG RAID */
> +	{ PCI_VDEVICE(INTEL, 0x2323), board_ahci }, /* DH89xxCC AHCI */
>

applied


