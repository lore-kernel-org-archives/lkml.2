Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab0GNHvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 03:51:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57559 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab0GNHvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 03:51:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vo863sMARRd+l82JH5dyR1nhkfRl0C/VWejgrvHVyVM2DQdooZK1QdQ0F2O+8dZvoM
         HWio/XBYnKai229Ba4ilw2cPG691OzN+4O7fgqe9OxlrSZifa4BKrjRGULo13LmhZuOp
         9KCwgHi0mIqjAG12M2YK4IsFZOpEHXoc2PgnE=
Message-ID: <4C3D6C90.4030709@pobox.com>
Date: Wed, 14 Jul 2010 03:51:44 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Rupjyoti Sarmah <rsarmah@amcc.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, rsarmah@apm.com,
        sr@denx.de, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v2]460EX on-chip SATA driver<resubmisison>
References: <201007061106.o66B631f013777@amcc.com>
In-Reply-To: <201007061106.o66B631f013777@amcc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2010 07:06 AM, Rupjyoti Sarmah wrote:
> This patch enables the on-chip DWC SATA controller of the AppliedMicro processor 460EX.
>
> Signed-off-by: Rupjyoti Sarmah<rsarmah@appliedmicro.com>
> Signed-off-by: Mark Miesfeld<mmiesfeld@appliedmicro.com>
> Signed-off-by: Prodyut Hazarika<phazarika@appliedmicro.com>
>
> ---
> This patch incorporates the changes advised in the mailing list. The device
> tree changes were submitted as a seperate patch. Kconfig file is fixed in this version.
>
>   drivers/ata/Kconfig          |    9 +
>   drivers/ata/Makefile         |    1 +
>   drivers/ata/sata_dwc_460ex.c | 1756 ++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 1766 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/ata/sata_dwc_460ex.c

applied


