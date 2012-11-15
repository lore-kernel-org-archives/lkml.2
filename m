Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab2KOJI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:08:29 -0500
Received: from zmail.sgconsulting.it ([174.143.207.116]:51267 "EHLO
	zmail.sgconsulting.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab2KOJIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:08:18 -0500
Date: Thu, 15 Nov 2012 09:09:35 +0000 (UTC)
From: Forconi <forconi@wavecomm.it>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Message-ID: <1851235145.1360402.1352970575153.JavaMail.root@zmail.sgconsulting.it>
In-Reply-To: <20121114171755.27b8423b@pyramind.ukuu.org.uk>
Subject: Re: KMS Framebuffer on Intel N2600 (GMA3600)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [213.243.236.19]
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - GC23 (Win)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,
thanks again for your answer.

Reading the manual of the board I found this specification:
LVDS: 24-bit dual channel via CH7511 thru eDP

The Chrontel CH7511 is a DisplayPort (DP/eDP) to LVDS converter.

So, what I understand is that the LVDS interface that comes out
from the connector on the board is connected to the CH7511 that
is connected to the DP/eDP port on the CPU.

Until now I was starting the kernel with video=LVDS-1.....,
maybe I have to use another video device like DVI to use the eDP port?



Regards,
Samuele.



----- Messaggio originale -----
Da: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
A: "Forconi" <forconi@wavecomm.it>
Cc: linux-kernel@vger.kernel.org
Inviato: Mercoledì, 14 novembre 2012 18:17:55
Oggetto: Re: KMS Framebuffer on Intel N2600 (GMA3600)

> This backlight problem appears only when I run linux with KMS framebuffer,
> when I run linux without KMS framebuffer, the backlight is always on.
> 
> Yes, I have ACPI enabled and ACPI backlight enabled, but running:
> echo 100 > /sys/class/backlight/psb-bl/brightness

psb-bl/backlight willbe the backlight of the graphics not the ACPI
driver. You may need to enable that and also hack the acpi_video code to
add it anyway on that device.

> But, in the end, this means that the driver si correctly loaded and the 
> framebuffer is running but the panel backlight is off?
> In other words, I can't see anything only because the backlight is off?

I think so.

> I don't know which could be the maximum value, there are any standard values
> for backlight settings? I could try setting some values and see what happens...

Unfortunately not - and I have no idea what overdriving it would do to
the hardware.

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
