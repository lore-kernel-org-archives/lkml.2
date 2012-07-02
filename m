Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab2GBGPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 02:15:44 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57906 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab2GBGPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 02:15:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120630234303.148c612b@halley>
References: <1340636918-7505-1-git-send-email-richard.genoud@gmail.com>
 <20120628205303.676fa2ea@halley> <1340974064.3070.177.camel@sauron.fi.intel.com>
 <20120630234303.148c612b@halley>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Mon, 2 Jul 2012 08:15:27 +0200
Message-ID: <CACQ1gAgbYq8BAbEVb0FBWLMiy+z9fOEeaQLcpavXOKvTQbLN_g@mail.gmail.com>
Subject: Re: [PATCH] UBI: add minimal amount of reserved erase blocks in Kconfig
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/30 Shmulik Ladkani <shmulik.ladkani@gmail.com>:
> Hi,
Hi,
> I thought to make it a gradual change.
>
> First, change the semantics of CONFIG_MTD_UBI_BEB_RESERVE to be the
> percent of total number of eraseblocks (instead of total number of
> _good_ eraseblocks). And 'reserve' counts for both existing bad PEBs
> and those reserved for future bad PEB handling.
> Note this would still be % of the blocks in the mtd partition (and as
> such, it is very loosely related to the MBB of the device, if at all).
>
> Then, Richard may introduce the MBB parameter to ubiattach, and later
> may kill CONFIG_MTD_UBI_BEB_RESERVE (if no longer needed). The
> calculations will be according to the new parameter.
>
> What do you say?
It's ok for me.

> On a side note, the new ubiattach parameter should not be called MBB,
> but rather a generic "reserved" (or "% reserved").
>
> This is since the MBB is a property of the mtd nand device.
> But the ubi user may issue, for the partition attached, a value other
> than the device's MBB, according to his storage needs and
> risks/securities he is willing to take.
>
> Regards,
> Shmulik



-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
