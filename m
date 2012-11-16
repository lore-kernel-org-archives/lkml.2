Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab2KPQbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:31:14 -0500
Received: from zmail.sgconsulting.it ([174.143.207.116]:41989 "EHLO
	zmail.sgconsulting.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab2KPQbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:31:13 -0500
Date: Fri, 16 Nov 2012 16:32:35 +0000 (UTC)
From: Forconi <forconi@wavecomm.it>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Message-ID: <421141140.1413640.1353083555907.JavaMail.root@zmail.sgconsulting.it>
In-Reply-To: <20121116154443.46b21508@pyramind.ukuu.org.uk>
Subject: Re: KMS Framebuffer on Intel N2600 (GMA3600)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [213.243.236.19]
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - GC23 (Win)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cedarview-drm ubuntu package version is 20120717.
This is modinfo cedarview_gfx output:
filename:       /lib/modules/3.2.0-33-generic/updates/dkms/cedarview_gfx.ko
license:        GPL
author:         Imagination Technologies Ltd. <gpl-support@imgtec.com>
license:        GPL
author:         Imagination Technologies Ltd. <gpl-support@imgtec.com>
license:        GPL
author:         Imagination Technologies Ltd. <gpl-support@imgtec.com>
license:        GPL
description:    drm driver for the Intel GMA500
author:         Intel Corporation
license:        GPL
author:         Imagination Technologies Ltd. <gpl-support@imgtec.com>
srcversion:     22A2B0E0BC65614D48C07F8
alias:          pci:v00008086d00000BEFsv*sd*bc*sc*i*
alias:          pci:v00008086d00000BEEsv*sd*bc*sc*i*
alias:          pci:v00008086d00000BEDsv*sd*bc*sc*i*
alias:          pci:v00008086d00000BECsv*sd*bc*sc*i*
alias:          pci:v00008086d00000BEBsv*sd*bc*sc*i*
alias:          pci:v00008086d00000BEAsv*sd*bc*sc*i*
alias:          pci:v00008086d00000BE9sv*sd*bc*sc*i*
alias:          pci:v00008086d00000BE8sv*sd*bc*sc*i*
alias:          pci:v00008086d00000BE7sv*sd*bc*sc*i*
alias:          pci:v00008086d00000BE6sv*sd*bc*sc*i*
alias:          pci:v00008086d00000BE5sv*sd*bc*sc*i*
alias:          pci:v00008086d00000BE4sv*sd*bc*sc*i*
alias:          pci:v00008086d00000BE3sv*sd*bc*sc*i*
alias:          pci:v00008086d00000BE2sv*sd*bc*sc*i*
alias:          pci:v00008086d00000BE1sv*sd*bc*sc*i*
alias:          pci:v00008086d00000BE0sv*sd*bc*sc*i*
depends:        ttm,drm,drm_kms_helper,video,i2c-algo-bit
vermagic:       3.2.0-33-generic SMP mod_unload modversions 686 
parm:           debug:Enable debug output (int)
parm:           trap_pagefaults:Error and reset on MMU pagefaults (int)
parm:           msvdx_pmpolicy:msvdx power management policy btw frames (int)
parm:           msvdx_command_delay:int
parm:           ospm:switch for ospm support (int)


Regards,
Samuele.

----- Messaggio originale -----
Da: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
A: "Forconi" <forconi@wavecomm.it>
Cc: linux-kernel@vger.kernel.org
Inviato: Venerdì, 16 novembre 2012 16:44:43
Oggetto: Re: KMS Framebuffer on Intel N2600 (GMA3600)

On Fri, 16 Nov 2012 14:50:54 +0000 (UTC)
Forconi <forconi@wavecomm.it> wrote:

> Hi Alan,
> I wasn't be able to make the Linux Framebuffer run on my kernel, even if the kernel config seems to be correct.
> I have decided to give a try to ubuntu-server because many users report to make their netbook screen work with cedarview-drm driver.
> To be short, I installed ubuntu-server, installed a non-pae kernel (3.2.0.33), installed cedarview-drm package and configured grub with video=LVDS-1:d.
> Framebuffer is up and running now with 800x480 resolution. I haven't investigated yet why ubuntu driver works and the one I built wit the 3.6.6 kernel not.

Glad to hear that. Can you let me know the version number of the
cedarview-drm driver you are using. That helps me as the open source
driver is derived from that code so I know if you've got a newer version
for example.

Alan

-- 
Ing. Samuele Forconi
Responsabile Sviluppo SW
WaveComm S.r.l.
Sede legale: Via Donizetti 25, 53011 Castellina in Chianti (SI)
Sede operativa: Loc. Belvedere - Ingresso 2, 53034 Colle Val d'Elsa (SI)
Phone: (39) 0577 043101
Fax: (39) 0577 043101
Mobile: (39) 347 5899717
Skype: samueleforconi
E-mail: forconi@wavecomm.it
URL: www.wavecomm.it

_____________________________________________________________________________________________

Ai sensi del D. Lgs. n.196 del 30/06/2003, questo messaggio ed ogni suo allegato sono confidenziali e ad uso esclusivo del destinatario, il quale è l'unico autorizzato ad usarlo, copiarlo e, sotto la propria responsabilità, diffonderlo. Se il ricevente non è il destinatario diretto del presente messaggio, è pregato di contattare l'originario mittente e di cancellare questo messaggio ed ogni suo allegato dal sistema di posta. Se il ricevente non è il destinatario diretto del presente messaggio, sono vietati l'uso, la riproduzione, e la stampa di questo messaggio e di ogni suo allegato, nonché la diffusione del loro contenuto a qualsiasi altro soggetto.

For the D. Lgs. n.196 of 30/06/2003, this message and any attachment are confidential and privileged for the the recipient identified above, who only may use, copy and, under his/her responsibility, further disseminate it. If you are not the intended recipient, please contact the sender and delete this message and any attachment from your system. If you are not the intended recipient you must not use, copy or print this message or attachment or disclose the contents to any other person.
