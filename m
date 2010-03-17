Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab0CQFzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 01:55:55 -0400
Received: from sdcmail02.amcc.com ([198.137.200.90]:29948 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab0CQFzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 01:55:53 -0400
X-IronPort-AV: E=Sophos;i="4.49,655,1262592000"; 
   d="scan'208";a="7479173"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] 460EX on-chip SATA driver<kernel 2.6.33> < resubmission : 01>
Date: Tue, 16 Mar 2010 22:55:51 -0700
Message-ID: <AC311A8E81420D4EBC1F26E6479848FE065B7F54@SDCEXCHANGE01.ad.amcc.com>
In-Reply-To: <20100317155959.208eea21.sfr@canb.auug.org.au>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH] 460EX on-chip SATA driver<kernel 2.6.33> < resubmission : 01>
Thread-Index: AcrFjrZVmShpAR3iR1+bzn+67Id3SwABxqcw
References: <1268646854-27387-1-git-send-email-rsarmah@appliedmicro.com><AC311A8E81420D4EBC1F26E6479848FE065B7F30@SDCEXCHANGE01.ad.amcc.com> <20100317155959.208eea21.sfr@canb.auug.org.au>
From: "Rupjyoti Sarmah" <rsarmah@amcc.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: <linux-ide@vger.kernel.org>, "Jeff Garzik" <jgarzik@pobox.com>,
       "Rupjyoti Sarmah" <rupjyoti.sarmah@gmail.com>,
       <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Thanks for your suggestions. 
I used git-send-email earlier and emails never appeared in the archive.
This time I sent through outlook & the message appeared in the archive.
Looks like outlook did that word wrap.

I am not sure why the emails from the git-send-email did not get
delivered. At the time of sending I got message delivered  logs.

Regards,
Rupjyoti Sarmah




-----Original Message-----
From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
Sent: Wednesday, March 17, 2010 10:30 AM
To: Rupjyoti Sarmah
Cc: linux-ide@vger.kernel.org; Jeff Garzik; Rupjyoti Sarmah;
linuxppc-dev@ozlabs.org; Rupjyoti Sarmah; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 460EX on-chip SATA driver<kernel 2.6.33> <
resubmission : 01>

Hi,

Just a couple of quick points ...

On Tue, 16 Mar 2010 21:23:16 -0700 "Rupjyoti Sarmah" <rsarmah@amcc.com>
wrote:
>
> This patch enables the on-chip DWC SATA controller of the AppliedMicro

> processor 460EX.
> 
> Signed-off-by: Rupjyoti Sarmah <rsarmah@appliedmicro.com> ,Mark 
> Miesfeld <mmiesfeld@appliedmicro.com>, Prodyut Hazarika 
> <phazarika@appliedmicro.com>

Please put one Signed-off-by line per person.

> ---
>  arch/powerpc/boot/dts/canyonlands.dts |    8 +
>  drivers/ata/Kconfig                   |    9 +
>  drivers/ata/Makefile                  |    1 +
>  drivers/ata/sata_dwc.c                | 1965
> +++++++++++++++++++++++++++++++++
>  4 files changed, 1983 insertions(+), 0 deletions(-)  create mode 
> 100644 drivers/ata/sata_dwc.c

This patch has been word wrapped by your mailer (or something along the
way).
--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
