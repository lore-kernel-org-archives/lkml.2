Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab2DDHV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 03:21:59 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60267 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab2DDHV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 03:21:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120403171736.GD2477@pengutronix.de>
References: <1333434302-14897-1-git-send-email-meltedpianoman@gmail.com>
	<20120403165320.GG19952@sequoia.sous-sol.org>
	<20120403170708.GC2477@pengutronix.de>
	<20120403171112.GH19952@sequoia.sous-sol.org>
	<20120403171736.GD2477@pengutronix.de>
Date: Wed, 4 Apr 2012 09:21:57 +0200
Message-ID: <CAMSQXEHpjD7LWQkKWJOU=9eFYqsaJi-xHFTxexQr7yoKiCG7HQ@mail.gmail.com>
Subject: Re: [PATCH-v3] Support M95040 SPI EEPROM
From: Ivo Sieben <meltedpianoman@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>,
        Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Op 3 april 2012 19:17 heeft Wolfram Sang <w.sang@pengutronix.de> het
volgende geschreven:
>
>> > > > +#define EE_INSTR_BIT3_IS_ADDR  0x0010
>> > >
>> > > Is there some guarantee that this chip flag will always have this
>> > > meaning?
>> >
>> > ? This is a driver flag.
>>
>> Sorry, I don't see it set anywhere, so unclear on where it comes from.
>> I thought it was from a generic spi probe.
>
> Yeah, agreed, 'struct spi_eeprom' does not sound much like platform_data :/
> Thanks for checking.

The flag is indeed used in the platform initialization to enable the
"address bit" behavior, so you don't see it set anywhere in this patch
(and not anywhere in the kernel, since no board uses this flag yet).

Is it OK if we leave this patch like this?

Regards,
Ivo Sieben
