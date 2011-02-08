Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1BHSbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 13:31:50 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64115 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371Ab1BHSbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 13:31:49 -0500
Message-ID: <4D518BBC.8050904@ru.mvista.com>
Date: Tue, 08 Feb 2011 21:30:20 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Sergei Shtylyov <sshtylyov@mvista.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 21/20] ata_piix: add new PIIX_FLAG_* flags
References: <201102081652.36752.bzolnier@gmail.com>	<4D51796C.8020008@ru.mvista.com> <AANLkTikyV579TRSMw_g_rTB7C641fWbdSELP9mpa30bG@mail.gmail.com>
In-Reply-To: <AANLkTikyV579TRSMw_g_rTB7C641fWbdSELP9mpa30bG@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

>>> Turn open-coded checks in piix_set_timings() into PIIX_FLAG_* flags
>>> per suggestion from Alan Cox.
>>> Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> [...]

>>> Index: b/drivers/ata/ata_piix.c
>>> ===================================================================
>>> --- a/drivers/ata/ata_piix.c
>>> +++ b/drivers/ata/ata_piix.c
>>> @@ -133,6 +133,8 @@ enum {
>>>        PIIX_FLAG_CHECKINTR     = (1 << 28), /* make sure PCI INTx enabled
>>> */
>>>        PIIX_FLAG_SIDPR         = (1 << 29), /* SATA idx/data pair regs */
>>> +       PIIX_FLAG_NO_SITRE      = (1 << 30), /* no SITRE register */

>>   The register in question is called SIDETIM, SITRE is a bit that enables
>> its use.

> ICH4-M databook that I have at hand (Intel IDE PRM seems to be gone
> from Intel's website, though I'm sure I have a backup _somewhere_) it
> is called SLV_IDETIM so lets just stick with the current naming for
> now..

    Why not just say that SITRE is a bit, not register? :-)

> Thanks,
> Bartlomiej

WBR, Sergei
