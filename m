Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab0GNP3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 11:29:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25970 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab0GNP3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 11:29:50 -0400
Date: Wed, 14 Jul 2010 08:25:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Marcel Selhorst <m.selhorst@sirrix.com>
Cc: "Dan.Morav@nuvoton.com" <Dan.Morav@nuvoton.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>,
        "srajiv@linux.vnet.ibm.co" <srajiv@linux.vnet.ibm.co>,
        "Michal.Schramm@nuvoton.com" <Michal.Schramm@nuvoton.com>
Subject: Re: Request to submit driver for Nuvoton TPM I2C device (WPCT301)
Message-Id: <20100714082531.d1e6d035.randy.dunlap@oracle.com>
In-Reply-To: <4C3D9810.10807@sirrix.com>
References: <8F2A7B0931C16B4C99DDA3B283A436301401CFB6@ntilml01.nuvoton.com>
	<4C3D9810.10807@sirrix.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C3DD778.01D3:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010 12:57:20 +0200 Marcel Selhorst wrote:

> Hi Dan,
> 
> thanks for the driver. When submitting the patch, could you please add some
> information, where / on what platforms this chip can be found?
> 
> Also, could you please rename your driver to tpm_nuvoton_i2c.c (or
> similar)? There are other I2C-TPM device drivers from other vendors
> currently in the process of being included and we need to distinguish
> between these.
> 
> I had a very quick look over your code, could you please put your #defines
> on top of the file? And please provide a complete patch (including KConfig
> / Makefile) against Linux instead of sending individual files.


It should also be submitted as a patch to the current kernel.
This matters for the Kconfig / Makefile changes.


> Thanks,
> Marcel
> 
> Am 14.07.2010 11:31, schrieb Dan.Morav@nuvoton.com:
> > Hello,
> > 
> > I'd like to submit a new TPM driver.
> > 
> > Attached is a new driver for Nuvoton TPM with I2C interface.
> > - tpm_i2c.c is the driver code
> > - tpm.h and Makefile are added only for reference and stand alone compilation
> > 
> > The driver should be part of the drivers/char/tpm.
> > The driver uses standard Linux I2C bus driver interface to access the I2C bus.
> > The driver uses standard Linux TPM driver API.
> > The driver was tested on Linux kernel v2.6.31.
> > 
> > Please advice if any further information is required.
> > 
> > Regards,
> > Dan.
> > _________________________
> > Dan Morav
> > Advanced PC
> > Nuvoton Technology Israel Ltd.
> > Office +972.9.970.2388
> > eMail: dan.morav@nuvoton.com
> > 
> > 
> > ===========================================================================================
> > The privileged confidential information contained in this email is intended for use only by the addressees as indicated by the original sender of this email. If you are not the addressee indicated in this email or are not responsible for delivery of the email to such a person, please kindly reply to the sender indicating this fact and delete all copies of it from your computer and network server immediately. Your cooperation is highly appreciated. It is advised that any unauthorized use of confidential information of Nuvoton is strictly prohibited; and any information in this email irrelevant to the official business of Nuvoton shall be deemed as neither given nor endorsed by Nuvoton.
> > 
> > ===========================================================================================
> > The privileged confidential information contained in this email is intended for use only by the addressees as indicated by the original sender of this email. If you are not the addressee indicated in this email or are not responsible for delivery of the email to such a person, please kindly reply to the sender indicating this fact and delete all copies of it from your computer and network server immediately. Your cooperation is highly appreciated. It is advised that any unauthorized use of confidential information of Nuvoton is strictly prohibited; and any information in this email irrelevant to the official business of Nuvoton shall be deemed as neither given nor endorsed by Nuvoton.
> 
> -- 
> Sirrix AG security technologies -- http://www.sirrix.com
> Dipl.-Ing. Marcel Selhorst  eMail: m.selhorst@sirrix.com
> Tel: +49 (234) 610071-126   Fax: +49 (234) 610071-526
> Tel: +49 (681)  95986-126   Fax: +49 (681)  95986-526
> Get my public key from keyserver, KeyId: 0x7C9821CC
> Fingerprint 4138 E617 E62E 79D3 E663 BE5A 14E7 1CD8 7C98 21CC
> 
> Vorstand: Ammar Alkassar (Vors.), Christian Stueble
> Vorsitzender des Aufsichtsrates: Prof. Dr. Kai Rannenberg
> Sitz der Gesellschaft: Homburg/Saar, HRB 3857 Amtsgericht Saarbruecken
> 
> This message may contain confidential and/or privileged information.
> If you are not the addressee, you must not use, copy, disclose or
> take any action based on this message or any information herein.
> If you have received this message in error, please advise the sender
> immediately by reply e-mail and delete this message.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
