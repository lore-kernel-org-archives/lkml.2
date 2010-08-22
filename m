Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab0HVTzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 15:55:00 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39068 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab0HVTy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 15:54:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ulWpv8Uij03V48OP5sKUv0x7qimpp0S4JVcDh0wDccqdTOvBQlXmzcflV4OTt7nxOp
         0DSm+uy2kSnPW9dSiS6DL/ldzzPrNewsxNVk2xEMUr/bmFFMHr0ElK4srFJRxYuEVnIS
         meQkS/AjJc06b7vpW4Gf6+2v+1exq/ZO35diQ=
Message-ID: <4C71808B.7070704@garzik.org>
Date: Sun, 22 Aug 2010 15:54:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Nicolas Jungers <nicolas@jungers.net>
CC: linux-kernel@vger.kernel.org,
        Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: possible esata regression in 2.6.35
References: <4C702070.5020809@jungers.net>
In-Reply-To: <4C702070.5020809@jungers.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2010 02:52 PM, Nicolas Jungers wrote:
> My arm box doesn't succeed to use my esata port multiplier (addonics
> sil3726 based). It was working well with 2.6.34.1 and 2.6.34.4 but not
> with both 2.6.35.2 and 2.6.35.3. I haven't test other kernels.
>
> The kernels are from http://sheeva.with-linux.com/sheeva/ with for
> example the following config
> http://sheeva.with-linux.com/sheeva/2.6.35.3/sheeva-2.6.35.3.config
>
> The symptoms are in the console a loop on the esata links. Here is the
> start of it:
>
> ata2: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0xe frozen
> ata2: edma_err_cause=00000010 pp_flags=00000000, dev connect
> ata2: SError: { PHYRdyChg DevExch }
> ata2: hard resetting link
> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
> ata2.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9

Can you post or link to the entire dmesg?

Notably, we need to see the probe messages to determine what SATA chip 
you are using...  From the edma_err_cause config I'd guess sata_mv, but 
more info would be useful.

	Jeff




