Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab0FITvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:51:14 -0400
Received: from xenotime.net ([72.52.115.56]:45432 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758216Ab0FITvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:51:11 -0400
Date: Wed, 9 Jun 2010 12:51:08 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jean Tourrilhes <jt@hpl.hp.com>
Subject: Re: [PATCH 12/12] Documentation/networking/wavelan.txt: Deleted,
 not in tree
Message-Id: <20100609125108.f1e9bda6.rdunlap@xenotime.net>
In-Reply-To: <bc9926adf314ed624f2f100f3badf05a9e2d9e27.1276112118.git.joe@perches.com>
References: <cover.1276112117.git.joe@perches.com>
	<bc9926adf314ed624f2f100f3badf05a9e2d9e27.1276112118.git.joe@perches.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Jun 2010 12:38:38 -0700 Joe Perches wrote:

> commit 1d794e3b353b50ab5d9d46f7c15607f9ec8c78e0 removed the source,
> so remove the documentation as well.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Cc: Jean Tourrilhes <jt@hpl.hp.com>
> Cc: Randy Dunlap <rdunlap@xenotime.net>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

Andrew, please push this patch.


> ---
>  Documentation/networking/wavelan.txt |   73 ----------------------------------
>  1 files changed, 0 insertions(+), 73 deletions(-)
>  delete mode 100644 Documentation/networking/wavelan.txt
> 
> diff --git a/Documentation/networking/wavelan.txt b/Documentation/networking/wavelan.txt
> deleted file mode 100644
> index afa6e52..0000000
> --- a/Documentation/networking/wavelan.txt
> +++ /dev/null
> @@ -1,73 +0,0 @@
> -	The Wavelan drivers saga
> -	------------------------
> -
> -	By Jean Tourrilhes <jt@hpl.hp.com>
> -
> -	The Wavelan is a Radio network adapter designed by
> -Lucent. Under this generic name is hidden quite a variety of hardware,
> -and many Linux driver to support it.
> -	The get the full story on Wireless LANs, please consult :
> -		http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/
> -
> -"wavelan" driver (old ISA Wavelan)
> -----------------
> -	o Config :	Network device -> Wireless LAN -> AT&T WaveLAN
> -	o Location :	.../drivers/net/wireless/wavelan*
> -	o in-line doc :	.../drivers/net/wireless/wavelan.p.h
> -	o on-line doc :
> -	    http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Wavelan.html
> -
> -	This is the driver for the ISA version of the first generation
> -of the Wavelan, now discontinued. The device is 2 Mb/s, composed of a
> -Intel 82586 controller and a Lucent Modem, and is NOT 802.11 compliant.
> -	The driver has been tested with the following hardware :
> -	o Wavelan ISA 915 MHz (full length ISA card) 
> -	o Wavelan ISA 915 MHz 2.0 (half length ISA card) 
> -	o Wavelan ISA 2.4 GHz (full length ISA card, fixed frequency) 
> -	o Wavelan ISA 2.4 GHz 2.0 (half length ISA card, frequency selectable) 
> -	o Above cards with the optional DES encryption feature 
> -
> -"wavelan_cs" driver (old Pcmcia Wavelan)
> --------------------
> -	o Config :	Network device -> PCMCIA network ->
> -				Pcmcia Wireless LAN -> AT&T/Lucent WaveLAN
> -	o Location :	.../drivers/net/pcmcia/wavelan*
> -	o in-line doc :	.../drivers/net/pcmcia/wavelan_cs.h
> -	o on-line doc :
> -	    http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Wavelan.html
> -
> -	This is the driver for the PCMCIA version of the first
> -generation of the Wavelan, now discontinued. The device is 2 Mb/s,
> -composed of a Intel 82593 controller (totally different from the 82586)
> -and a Lucent Modem, and NOT 802.11 compatible.
> -	The driver has been tested with the following hardware :
> -	o Wavelan Pcmcia 915 MHz 2.0 (Pcmcia card + separate
> -					modem/antenna block) 
> -	o Wavelan Pcmcia 2.4 GHz 2.0 (Pcmcia card + separate
> -					modem/antenna block) 
> -
> -"wvlan_cs" driver (Wavelan IEEE, GPL)
> ------------------
> -	o Config :	Not yet in kernel
> -	o Location :	Pcmcia package 3.1.10+
> -	o on-line doc :	http://www.fasta.fh-dortmund.de/users/andy/wvlan/
> -
> -	This is the driver for the current generation of Wavelan IEEE,
> -which is 802.11 compatible. Depending on version, it is 2 Mb/s or 11
> -Mb/s, with or without encryption, all implemented in Lucent specific
> -DSP (the Hermes).
> -	This is a GPL full source PCMCIA driver (ISA is just a Pcmcia
> -card with ISA-Pcmcia bridge).
> -
> -"wavelan2_cs" driver (Wavelan IEEE, binary)
> ---------------------
> -	o Config :	Not yet in kernel
> -	o Location :	ftp://sourceforge.org/pcmcia/contrib/
> -
> -	This driver support exactly the same hardware as the previous
> -driver, the main difference is that it is based on a binary library
> -and supported by Lucent.
> -
> -	I hope it clears the confusion ;-)
> -
> -	Jean
> -- 
> 1.7.1.244.gbdc4
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
