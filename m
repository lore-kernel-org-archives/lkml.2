Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab1DMN7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:59:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41144 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab1DMN7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:59:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gTXM5toYuVtnH4YQ6BfXyh+3A16X82xhu4ektqYjbhPtRXY4/1q4xf0KgKIqWLkHHg
         L2yFZoTt4DIw9ArGI2+cFCd8YD4QfK8tU8hNhWh/SEv5AxlWqqL609vTQx1bo5cKBVaV
         UnpSVD7rr/1o48eqPgHcwHPyIAUr+ylX9zE/8=
Message-ID: <4DA5AC40.9070307@gmail.com>
Date: Wed, 13 Apr 2011 15:59:28 +0200
From: "=?UTF-8?B?QW5kcmVhcyBCaWXDn21hbm4=?=" <andreas.devel@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        AVR32 Linux Kernel <kernel@avr32linux.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] AVR32 fixes and minor updates for 2.6.39
References: <1302702816.10549.7.camel@hcegtvedt>
In-Reply-To: <1302702816.10549.7.camel@hcegtvedt>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Hans-Christian Egtvedt,

Am 13.04.2011 15:53, schrieb Hans-Christian Egtvedt:
> Jean-Christophe PLAGNIOL-VILLARD (1):
>       avr32: At32ap: pio fix typo "))" on gpio_irq_unmask prototype

You may have missed

Jean-Christophe PLAGNIOL-VILLARD:
	avr32: At32ap: fix extint irq_chip type from irq_chip to irq_data

It is required for extint.c to compile.

regards

Andreas Bießmann
