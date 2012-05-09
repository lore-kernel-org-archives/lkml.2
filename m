Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761101Ab2EIUha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:37:30 -0400
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:57189 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761086Ab2EIUh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:37:28 -0400
Message-ID: <4FAAD584.70102@hrz.tu-chemnitz.de>
Date: Wed, 09 May 2012 22:37:24 +0200
From: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Greg KH <greg@kroah.com>,
        Markus Franke <markus.franke@s2002.tu-chemnitz.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
References: <20120430021300.GA18148@kroah.com> <4FA1953B.40008@hrz.tu-chemnitz.de> <20120502202134.GB26628@kroah.com> <20120503180056.GB13988@ioremap.net>
In-Reply-To: <20120503180056.GB13988@ioremap.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Scan-AV: cora.hrz.tu-chemnitz.de;2012-05-09 22:37:25;47a88c12793755ae83773114e3953a1c
X-Scan-SA: cora.hrz.tu-chemnitz.de;2012-05-09 22:37:25;ada2ed63b3087e8ad3fe91cff5ae10f1
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Evgeniy,

I have reworked the patch and now I am not getting any checkpatch
warnings or errors anymore.

How about the binary sysfs files? If I understand correctly I would add
a documentation file under Documentation/w1/slaves which documents both
sysfs files (eeprom & pio).

@Greg: Could you live with those driver specific binary sysfs files?

Best regards,
Markus Franke

Am 03.05.2012 20:00, schrieb Evgeniy Polyakov:

> On Wed, May 02, 2012 at 01:21:34PM -0700, Greg KH (greg@kroah.com) wrote:
>>> Well, I just stuck to the way things are done in already existing
>>> drivers e.g. drivers/w1/slaves/w1_ds2433.c
>>
>> Really?  Ick, where are those files documented?
> 
> I'm kinda lost here.
> 
> To clarify things a bit - w1 allows to create 'private' sysfs files for
> special functionality which exists only in given driver - like
> enable/disable checksum and so on. It has to be documented and must
> follow common kernel codying standards of course.
> 


