Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab0LSW5e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 17:57:34 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50246 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab0LSW5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 17:57:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GBDDNhpEwphMrlp/SLI0tbDSIe3/yvzD0eiexXB68EoAqA0pXrXH9W7d3MB9Ki39sj
         boxjAD4/SSKtxdia5DRBjasJ7fO6Do/UgwPaHjW4swfOUgIRJu3N1k2X4ctpud3068ve
         79boIxh+RRXnrMm/HLsLTuJygghVp93Q6oxGU=
MIME-Version: 1.0
In-Reply-To: <AANLkTimCYea+G7Z+o-2BDCGHbRobM2n+VJLLcDO6g=9d@mail.gmail.com>
References: <1292584829-28279-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
	<AANLkTimCYea+G7Z+o-2BDCGHbRobM2n+VJLLcDO6g=9d@mail.gmail.com>
Date: Sun, 19 Dec 2010 23:57:31 +0100
Message-ID: <AANLkTi=J1AdOgxA_S9p9Ts65PL3Mi5NXXWMf0f-=0AwN@mail.gmail.com>
Subject: Re: [PATCH 00/11] mfd and bluetooth: Add CG2900 support
From: Vitaly Wool <vitalywool@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>,
        Pavan Savoy <pavan_savoy@sify.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sun, Dec 19, 2010 at 10:23 PM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> I'm slightly confused by different comment threads on this patch set.

let me first first repost the part from Arnd's email on the
architecture of the "shared transport" type of thing:

> I believe we already agree it should be something like
>
>   bt   ti-radio    st-e-radio    ti-gps   st-e-gps  broadcom-radio ...
>   |         |          |            |          |          |         |
>   +---------+----------+---------+--+----------+----------+---------+
>                                  |
>                         common-hci-module
>                                  |
>                      +-----------+-----------+
>                      |        |       |      |
>                    serial    spi     i2c    ...

I think an explanation on how the patchset from Par maps to this
architecture could be a good starting point for confusion minimization
:)

Thanks,
   Vitaly
