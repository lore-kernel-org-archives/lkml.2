Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab1KJV1C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 16:27:02 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34666 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab1KJV07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 16:26:59 -0500
Message-ID: <4EBC41A0.4070008@pobox.com>
Date: Thu, 10 Nov 2011 16:26:56 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: linux-next: Tree for Nov 1 (ata/libata-sff.c)
References: <20111101205323.c12f2f940f23febba8ab8989@canb.auug.org.au> <4EB0854D.5090002@xenotime.net>
In-Reply-To: <4EB0854D.5090002@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2011 07:48 PM, Randy Dunlap wrote:
> On 11/01/2011 02:53 AM, Stephen Rothwell wrote:
>> Hi all,
>
>
> When ATA_SFF is enabled but ATA_BMDMA is not enabled:
>
>
> drivers/ata/libata-sff.c: In function 'ata_pci_init_one':
> drivers/ata/libata-sff.c:2538:3: error: implicit declaration of function 'ata_pci_bmdma_prepare_host'
> drivers/ata/libata-sff.c:2549:40: error: 'ata_bmdma_interrupt' undeclared (first use in this function)

Absjoern's patch seen, thanks.



