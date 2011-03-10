Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab1CJXjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:39:35 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37888 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1CJXje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:39:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=nvE0Q0D8fl4xouslQakWKd2zfWgqxZFvpkjKpeccf2WQ5c4/LYSkm9KMNRStcHVSd4
         xpfUluT0/aCsZ8tqr11cqFveTxM3pcq0EMNsI9ij8NcxhlH7gHf53S1u80/q9WBoGI7j
         bFDhQxAoVL8yjOJpeYd8p/Vwoxq5AK37IgYvw=
Message-ID: <4D796132.1030007@gmail.com>
Date: Thu, 10 Mar 2011 15:39:30 -0800
From: Konstantin Svist <fry.kun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b2 Mnenhy/0.8.2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Can I build/test AHCI module on a live system? [was: PMP on Marvell
 6121]
References: <4D77D4FA.50604@gmail.com>
In-Reply-To: <4D77D4FA.50604@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there an easy way of recompiling/trying the AHCI module without 
having to recompile the entire kernel/rebooting?

Thanks


On 03/09/2011 11:28 AM, Konstantin Svist wrote:
> I'm trying to get port multiplier working on Marvell 6121 esata port.
> So far, I've found lkml discussion on how AHCI doesn't seem to support 
> it [1] and verified that it's still the case.
> sata_mv doesn't support it either - I only see the 1st drive in the 
> multiplier
>
> There used to be an official Asus driver called mv_thor [2] for really 
> old versions (2.6.20-something) and someone maintained it until 2.6.27 
> [3].
> The good news is I tried it on 2.6.27 (Fedora 10) and it works!
>
> Questions:
> Can someone who knows how the AHCI driver works take a look at the 
> mv_thor code and figure out why PMP doesn't work in AHCI driver? Most 
> likely it's just some quirk to get the chip initialized...
>
> And since the answer to the previous is most likely "we're too busy, 
> look at it yourself" the followup question is
> Is there an easy way of recompiling/trying the AHCI module without 
> having to recompile the entire kernel/rebooting?
>
> Thanks!
>
>
> [1] http://marc.info/?t=121747549500001&r=1&w=1
> [2] 
> http://en.wikipedia.org/wiki/List_of_Marvell_Technology_Group_chipsets#Linux_SATA_driver
> [3] http://forums.gentoo.org/viewtopic-p-5213724.html#5213724
>
>
