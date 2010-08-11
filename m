Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab0HKTQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 15:16:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61265 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab0HKTQi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 15:16:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e0e7Cpu4pbuveBnvn6muLrT7RRZYgTdIK5qIpQU+LpPITXSAaesgsgSrbjX/t2socG
         jUsYZJpSnNHHQYwV20ugl/2AL03dslPYbzm8J+HSjlaws++SUUKP6MRk8S6Q37MTkUq+
         pT/m/zzp3BbzRUMgC05vbwKwTxbx3Cy0QSLMQ=
MIME-Version: 1.0
In-Reply-To: <4C62DB6E.5010001@lockie.ca>
References: <4C62DB6E.5010001@lockie.ca>
Date: Wed, 11 Aug 2010 15:16:37 -0400
Message-ID: <AANLkTim9nBbKOD5io0JSS7VTC+UydKYyn8Uts0fYTY-5@mail.gmail.com>
Subject: Re: kernel config
From: Brian Waters <brianmwaters@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: James <bjlockie@lockie.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you think this is a good idea, then you should try submitting a
patch for it. The file you want to modify is drivers/ata/Kconfig. It
should be pretty obvious what to change. There is lots of info online
about creating patches.

- Brian Waters




On Wed, Aug 11, 2010 at 1:18 PM, James <bjlockie@lockie.ca> wrote:
>  CONFIG_SATA_AHCI
> │ This option enables support for AHCI Serial ATA. │
> │ │
> │ If unsure, say N.
>
> CONFIG_ATA_SFF: │
> │ │
> │ This option adds support for ATA controllers with SFF │
> │ compliant or similar programming interface. │
> │ │
> │ SFF is the legacy IDE interface that has been around since │
> │ the dawn of time. Almost all PATA controllers have an │
> │ SFF interface. Many SATA controllers have an SFF interface │
> │ when configured into a legacy compatibility mode. │
> │ │
> │ For users with exclusively modern controllers like AHCI, │
> │ Silicon Image 3124, or Marvell 6440, you may choose to │
> │ disable this unneeded SFF support.
>
>
> I recently configured and compiled the 2.6.35.1 kernel.
> I suggest moving
> │
> │ For users with exclusively modern controllers like AHCI, │
> │ Silicon Image 3124, or Marvell 6440, you may choose to │
> │ disable this unneeded SFF support.
> to the CONFIG_SATA_AHCI option.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
