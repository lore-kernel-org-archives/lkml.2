Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab2KPOts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:49:48 -0500
Received: from zmail.sgconsulting.it ([174.143.207.116]:58832 "EHLO
	zmail.sgconsulting.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2KPOtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:49:31 -0500
Date: Fri, 16 Nov 2012 14:50:54 +0000 (UTC)
From: Forconi <forconi@wavecomm.it>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Message-ID: <2005140186.1409370.1353077454668.JavaMail.root@zmail.sgconsulting.it>
In-Reply-To: <20121115125749.3604ebdf@pyramind.ukuu.org.uk>
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
I wasn't be able to make the Linux Framebuffer run on my kernel, even if the kernel config seems to be correct.
I have decided to give a try to ubuntu-server because many users report to make their netbook screen work with cedarview-drm driver.
To be short, I installed ubuntu-server, installed a non-pae kernel (3.2.0.33), installed cedarview-drm package and configured grub with video=LVDS-1:d.
Framebuffer is up and running now with 800x480 resolution. I haven't investigated yet why ubuntu driver works and the one I built wit the 3.6.6 kernel not.

Thanks again for your support.

Regards,
Samuele.




----- Messaggio originale -----
Da: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
A: "Forconi" <forconi@wavecomm.it>
Cc: linux-kernel@vger.kernel.org
Inviato: Giovedì, 15 novembre 2012 13:57:49
Oggetto: Re: KMS Framebuffer on Intel N2600 (GMA3600)

On Thu, 15 Nov 2012 09:09:35 +0000 (UTC)
Forconi <forconi@wavecomm.it> wrote:

> Hi Alan,
> thanks again for your answer.
> 
> Reading the manual of the board I found this specification:
> LVDS: 24-bit dual channel via CH7511 thru eDP
> 
> The Chrontel CH7511 is a DisplayPort (DP/eDP) to LVDS converter.
> 
> So, what I understand is that the LVDS interface that comes out
> from the connector on the board is connected to the CH7511 that
> is connected to the DP/eDP port on the CPU.
> 
> Until now I was starting the kernel with video=LVDS-1.....,
> maybe I have to use another video device like DVI to use the eDP port?

Could help explain why there is no backlight. Initial eDP support got
added to the driver very recently so it might work but it should still
have decided itself you have eDP given a current kernel.

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
