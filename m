Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742Ab2EJEzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 00:55:44 -0400
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:50370 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab2EJEzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 00:55:43 -0400
Message-ID: <4FAB4A4D.8080901@hrz.tu-chemnitz.de>
Date: Thu, 10 May 2012 06:55:41 +0200
From: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Greg KH <greg@kroah.com>,
        Markus Franke <markus.franke@s2002.tu-chemnitz.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
References: <4FA1953B.40008@hrz.tu-chemnitz.de> <20120502202134.GB26628@kroah.com> <20120503180056.GB13988@ioremap.net> <4FAAD584.70102@hrz.tu-chemnitz.de> <20120509220636.GA27659@kroah.com> <4FAAECB7.8070904@hrz.tu-chemnitz.de> <20120509222411.GA24302@kroah.com> <4FAAF1C4.2050500@hrz.tu-chemnitz.de> <20120509235723.GA7404@ioremap.net> <20120510000126.GA2357@kroah.com> <20120510004350.GA8362@ioremap.net>
In-Reply-To: <20120510004350.GA8362@ioremap.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Scan-AV: cora.hrz.tu-chemnitz.de;2012-05-10 06:55:42;052f32bb6eeb51b5858e470c6c3f46c6
X-Scan-SA: cora.hrz.tu-chemnitz.de;2012-05-10 06:55:42;0fd19e80c2e62ba03a220aa46db67695
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Evgeniy,

Am 10.05.2012 02:43, schrieb Evgeniy Polyakov:

> be used? Also, Markus, does DS28E04 change written/read data when doing
> IO?


Apart from masking the upper 6 bits within w1_f1C_write_pio() the data
is directly being passed down to the DS28E04. So actually there is no
other processing done within the driver. Furthermore, I added a new
Documentation file to Documentation/w1/slaves directory which describes
the interface of this driver.

@Greg: Is the "pio" binary file now legitimate or do I have to change it
to a regular sysfs attribute?

Best regards,
Markus Franke
