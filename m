Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab1FTEZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 00:25:22 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:39286 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1FTEZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 00:25:22 -0400
MIME-Version: 1.0
In-Reply-To: <4DFE9D6F.4030107@dsn.okisemi.com>
References: <4DEDBE90.3090305@dsn.okisemi.com> <20110607172211.GF17754@ponder.secretlab.ca>
 <4DFE9D6F.4030107@dsn.okisemi.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 19 Jun 2011 22:25:01 -0600
X-Google-Sender-Auth: L-SjeXUJLMc83Vjntf4FrfEd6bg
Message-ID: <BANLkTikVZ47BpD8j=_7mivNE3p1DtiRBXQ@mail.gmail.com>
Subject: Re: [RESEND]: RE: [PATCH v2 3/3] pch_gpio: support interrupt function
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com,
        toshiharu-linux@dsn.okisemi.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 7:07 PM, Tomoya MORINAGA
<tomoya-linux@dsn.okisemi.com> wrote:
> Hi Grant
>
> (2011/06/08 2:22), Grant Likely wrote:
>>
>> You don't need to implement new irq_chip
>> operations if you use the new irq_chip_generic implementation.
>>
>
> I have recently started implementing GPIO interrupt using irq_chip_generic.
> However, the compile becomes failed.
>  irq_alloc_generic_chip: undefined reference
>  irq_setup_generic_chip: undefined reference
>
> It seems irq_chip_generic is only ARM code.(linux-3.0-rc3)
> Does X86 support irq_chip_generic ?

Make sure your driver has "select GENERIC_IRQ_CHIP" in the Kconfig entry.

g.
