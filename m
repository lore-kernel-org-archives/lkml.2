Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab2EIWQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:16:30 -0400
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:35401 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519Ab2EIWQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:16:26 -0400
Message-ID: <4FAAECB7.8070904@hrz.tu-chemnitz.de>
Date: Thu, 10 May 2012 00:16:23 +0200
From: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Markus Franke <markus.franke@s2002.tu-chemnitz.de>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
References: <20120430021300.GA18148@kroah.com> <4FA1953B.40008@hrz.tu-chemnitz.de> <20120502202134.GB26628@kroah.com> <20120503180056.GB13988@ioremap.net> <4FAAD584.70102@hrz.tu-chemnitz.de> <20120509220636.GA27659@kroah.com>
In-Reply-To: <20120509220636.GA27659@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Scan-AV: cora.hrz.tu-chemnitz.de;2012-05-10 00:16:24;47253ee44ef3ebf21b48b1626159aba9
X-Scan-SA: cora.hrz.tu-chemnitz.de;2012-05-10 00:16:24;26911bcf60988cde5d3b437d89913737
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg,

the file "pio" is used for reading the current PIO state of the
DS28E04-100. The "eeprom" file is for reading/writing the EEPROM memory
of the same device.

As already mentioned before this is exactly the way how other w1 slave
drivers are handling stuff like this. I could also wrap everything
within a character device driver if this the way you would prefer. If
not, then please give me some advise how to exchange these couple of
bytes between user and kernel space.

Best regards,
Markus Franke

Am 10.05.2012 00:06, schrieb Greg KH:

> On Wed, May 09, 2012 at 10:37:24PM +0200, Markus Franke wrote:
>> Dear Evgeniy,
>>
>> I have reworked the patch and now I am not getting any checkpatch
>> warnings or errors anymore.
>>
>> How about the binary sysfs files? If I understand correctly I would add
>> a documentation file under Documentation/w1/slaves which documents both
>> sysfs files (eeprom & pio).
>>
>> @Greg: Could you live with those driver specific binary sysfs files?
> 
> Why do you need them?  What are they there for?
> 
> greg k-h
> 


