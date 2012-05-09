Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab2EIWh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:37:59 -0400
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:36383 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab2EIWh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:37:58 -0400
Message-ID: <4FAAF1C4.2050500@hrz.tu-chemnitz.de>
Date: Thu, 10 May 2012 00:37:56 +0200
From: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Markus Franke <markus.franke@s2002.tu-chemnitz.de>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
References: <20120430021300.GA18148@kroah.com> <4FA1953B.40008@hrz.tu-chemnitz.de> <20120502202134.GB26628@kroah.com> <20120503180056.GB13988@ioremap.net> <4FAAD584.70102@hrz.tu-chemnitz.de> <20120509220636.GA27659@kroah.com> <4FAAECB7.8070904@hrz.tu-chemnitz.de> <20120509222411.GA24302@kroah.com>
In-Reply-To: <20120509222411.GA24302@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Scan-AV: cora.hrz.tu-chemnitz.de;2012-05-10 00:37:57;d2e39065937922efa51d5d8413f3f26c
X-Scan-SA: cora.hrz.tu-chemnitz.de;2012-05-10 00:37:57;4770c60618490a01d4253795649da440
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg,

Am 10.05.2012 00:24, schrieb Greg KH:

>> the file "pio" is used for reading the current PIO state of the
>> DS28E04-100.
> 
> Why is this a binary file?  That seems like it should not be, as a
> binary sysfs file should be "pass-through" only.


Well, the data read/written through this file is actually directly
"passed" on to the device. There are two bits which reflect the current
state of the PIO pins of the DS28E04. However, I must admit that this
could also be implemented as regular sysfs attributes.

Best regards,
Markus Franke
