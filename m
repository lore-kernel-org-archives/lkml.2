Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab0KCQYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 12:24:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48503 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab0KCQYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 12:24:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UoB4sF/b+tVMmdZhM0PC9dNmTdFlBrRPPxtuqcLymfkf6QrYCEgOBLTGM9D53M8KyL
         /RLU8bdNwTjBL2j/4H8CBMEodUu5iQmcmhvPv2sQNibDPHpv/TXDLMi4Rl51iECnnY+9
         ApZPF++57f92/VoNOgeHnllaWQcxcNrSIQnJE=
MIME-Version: 1.0
In-Reply-To: <129498.93810.qm@web180302.mail.gq1.yahoo.com>
References: <AANLkTin=3K0H+YdNM2Nhz63c3+Upp+rwApo-Ww4p5qH6@mail.gmail.com>
	<129498.93810.qm@web180302.mail.gq1.yahoo.com>
Date: Wed, 3 Nov 2010 17:24:09 +0100
Message-ID: <AANLkTikZNMRLiWnDuY9oahwoJ+Zxsrvz=JO0C10CbZvx@mail.gmail.com>
Subject: Re: [PATCH v4 08/12] gpio: add ti-ssp gpio driver
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net, Cyril Chemparathy <cyril@ti.com>,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, lrg@slimlogic.co.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/3 David Brownell <david-b@pacbell.net>:
> --- On Wed, 11/3/10, Linus Walleij <linus.ml.walleij@gmail.com> wrote:
>>
>> Incidentally the ARM PrimeCell PL022 is called SSP,
>> "Synchronous Serial Port" and is not multifunction at all.
>
> ISTR coming across that IP module; are you sure
> that it only supports a single serial protocol,
> instead of just a "small" variety" (multi)?
> Unless the hardware only supports one protocol,
> my point holds.

Yeah well:

/**
 * enum ssp_interface - interfaces allowed for this SSP Controller
 * @SSP_INTERFACE_MOTOROLA_SPI: Motorola Interface
 * @SSP_INTERFACE_TI_SYNC_SERIAL: Texas Instrument Synchronous Serial
 * interface
 * @SSP_INTERFACE_NATIONAL_MICROWIRE: National Semiconductor Microwire
 * interface
 * @SSP_INTERFACE_UNIDIRECTIONAL: Unidirectional interface (STn8810
 * &STn8815 only)
 */
enum ssp_interface {
        SSP_INTERFACE_MOTOROLA_SPI,
        SSP_INTERFACE_TI_SYNC_SERIAL,
        SSP_INTERFACE_NATIONAL_MICROWIRE,
        SSP_INTERFACE_UNIDIRECTIONAL
};

If that is what you mean then yes. All of the protols are
"SPI type" though.

Yours,
Linus Walleij
