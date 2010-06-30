Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab0F3SnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:43:15 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61510 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab0F3SnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:43:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=RupoRvzqlLpTLzYK8XDmhfI2u0c8KFfSdBBZyfBDTBwoOZ9kTzMr33MSC+wOp+x7Bv
         1Fm9TTysKvNQYmmxk22JXKveXUUlrvgP+7q1oLVz4ap4Oi+TkLVUQQ0xCGjuFexqM36a
         nAvEufRVVD4W2W1p6QnwraSMLXy4BdQqxaoNY=
MIME-Version: 1.0
In-Reply-To: <AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	<4C29420D.2010406@intel.com>
	<AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>
	<4C2A8879.8010000@intel.com>
	<AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>
	<4C2AC55E.3040303@intel.com>
	<AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>
Date: Wed, 30 Jun 2010 11:43:01 -0700
X-Google-Sender-Auth: Yrc22mMoSMc0bgA_QNMcHmCta3k
Message-ID: <AANLkTilFeksHShFL6Y7LbgLQLFTuFS3cfFyDmPG0CKZh@mail.gmail.com>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: Chris Li <lkml@chrisli.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, david.woodhouse@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 11:26 AM, Chris Li <lkml@chrisli.org> wrote:
> iommu=off cause the kernel not boot properly. BTW, that is why I lost
> my machine remotely last night. There is some sata error keep printing on
> the console. Let me try to collect that once I reboot the machine again.

The error is flushing the screen very fast. Now it stops. I type the
last one in:

nommu_map_sg: overflow 270e3800+256 of device mask fffffff
ata1.00: execption Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
sr 0:0:0:0: [sr0] CDB: Inquiry: 12 00 00 00 fe 00
ata1.00: cmd a0/01:00:00:fe:00/00/00:00:00:00:00/a0 tag 0 dma 16640 in
             res 50/00:03:16:00:00/00:00:00:00:00:00/a0 Emask 0x40
(internal error)
ata1.00: status: {DRDY}
ata1.00: configured for UDMA/166
ata1: EH complete

I get lost of those.

Chris
