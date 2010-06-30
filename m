Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab0F3Moy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 08:44:54 -0400
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:34351 "HELO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752848Ab0F3Mow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 08:44:52 -0400
From: Rupjyoti Sarmah <rsarmah@apm.com>
References: <201006241327.o5ODRY6m032299@amcc.com> <20100630115808.2D9241524EC@gemini.denx.de>
In-Reply-To: <20100630115808.2D9241524EC@gemini.denx.de>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
thread-index: AcsYS4VoPCq8HoKmQ+q4NaKH1BlSAwABa9Rw
Date: Wed, 30 Jun 2010 18:14:47 +0530
Message-ID: <3b928476b2fffdcf0694e5436e8a482f@mail.gmail.com>
Subject: RE: [PATCH v1]460EX on-chip SATA driver<resubmisison>
To: Wolfgang Denk <wd@denx.de>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       sr@denx.de, linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfgang,

I took the mainline kernel v2.6.35-rc3 and downloaded using the git
download link.
I created the patch on 6/24/2010 after doing a git pull.

With the kernel tree on 6/24/2010 the driver compiled. I also tested the
functionality on the SATA drive & it worked.

Regards,
Rup



-----Original Message-----
From: Wolfgang Denk [mailto:wd@denx.de]
Sent: Wednesday, June 30, 2010 5:28 PM
To: Rupjyoti Sarmah
Cc: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org;
jgarzik@pobox.com; sr@denx.de; rsarmah@apm.com; linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v1]460EX on-chip SATA driver<resubmisison>

Dear Rupjyoti Sarmah,

In message <201006241327.o5ODRY6m032299@amcc.com> you wrote:
> This patch enables the on-chip DWC SATA controller of the AppliedMicro
processor 460EX.
>
> Signed-off-by: Rupjyoti Sarmah <rsarmah@appliedmicro.com>
> Signed-off-by: Mark Miesfeld <mmiesfeld@appliedmicro.com>
> Signed-off-by: Prodyut Hazarika <phazarika@appliedmicro.com>
>
> ---
> This patch incorporates the changes advised in the mailing list. The
device
> tree changes were submitted as a seperate patch.

Which kernel is this patch supposed to be applied to?

Using current mainline (v2.6.35-rc3-262-g984bc96) the patch applies
without problems, but when I enable it in the kernel configuration I
get this:

drivers/ata/sata_dwc_460ex.c:43:1: warning: "DRV_NAME" redefined
In file included from drivers/ata/sata_dwc_460ex.c:38:
drivers/ata/libata.h:31:1: warning: this is the location of the previous
definition
drivers/ata/sata_dwc_460ex.c:44:1: warning: "DRV_VERSION" redefined
drivers/ata/libata.h:32:1: warning: this is the location of the previous
definition
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_scr_read':
drivers/ata/sata_dwc_460ex.c:777: error: 'struct ata_port' has no member
named 'ioaddr'
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_scr_write':
drivers/ata/sata_dwc_460ex.c:793: error: 'struct ata_port' has no member
named 'ioaddr'
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_error_intr':
drivers/ata/sata_dwc_460ex.c:844: error: 'struct ata_port_operations' has
no member named 'sff_check_status'
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_isr':
drivers/ata/sata_dwc_460ex.c:953: error: 'struct ata_port_operations' has
no member named 'sff_check_status'
drivers/ata/sata_dwc_460ex.c:957: error: 'struct ata_port_operations' has
no member named 'sff_check_status'
drivers/ata/sata_dwc_460ex.c:991: error: implicit declaration of function
'ata_sff_hsm_move'
drivers/ata/sata_dwc_460ex.c:1030: error: 'struct ata_port_operations' has
no member named 'sff_check_status'
drivers/ata/sata_dwc_460ex.c: At top level:
drivers/ata/sata_dwc_460ex.c:1213: warning: 'struct ata_ioports' declared
inside parameter list
drivers/ata/sata_dwc_460ex.c:1213: warning: its scope is only this
definition or declaration, which is probably not what you want
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_setup_port':
drivers/ata/sata_dwc_460ex.c:1215: error: dereferencing pointer to
incomplete type
drivers/ata/sata_dwc_460ex.c:1216: error: dereferencing pointer to
incomplete type
drivers/ata/sata_dwc_460ex.c:1218: error: dereferencing pointer to
incomplete type
drivers/ata/sata_dwc_460ex.c:1219: error: dereferencing pointer to
incomplete type
drivers/ata/sata_dwc_460ex.c:1221: error: dereferencing pointer to
incomplete type
drivers/ata/sata_dwc_460ex.c:1223: error: dereferencing pointer to
incomplete type
drivers/ata/sata_dwc_460ex.c:1224: error: dereferencing pointer to
incomplete type
drivers/ata/sata_dwc_460ex.c:1225: error: dereferencing pointer to
incomplete type
drivers/ata/sata_dwc_460ex.c:1227: error: dereferencing pointer to
incomplete type
drivers/ata/sata_dwc_460ex.c:1228: error: dereferencing pointer to
incomplete type
drivers/ata/sata_dwc_460ex.c:1229: error: dereferencing pointer to
incomplete type
drivers/ata/sata_dwc_460ex.c:1231: error: dereferencing pointer to
incomplete type
drivers/ata/sata_dwc_460ex.c:1232: error: dereferencing pointer to
incomplete type
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_port_start':
drivers/ata/sata_dwc_460ex.c:1273: error: 'struct ata_port' has no member
named 'bmdma_prd'
drivers/ata/sata_dwc_460ex.c:1274: error: 'struct ata_port' has no member
named 'bmdma_prd_dma'
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_exec_command_by_tag':
drivers/ata/sata_dwc_460ex.c:1356: warning: passing argument 1 of
'ata_get_cmd_descript' makes integer from pointer without a cast
drivers/ata/sata_dwc_460ex.c:1369: error: implicit declaration of function
'ata_sff_exec_command'
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_qc_issue':
drivers/ata/sata_dwc_460ex.c:1512: error: 'struct ata_port_operations' has
no member named 'sff_tf_load'
drivers/ata/sata_dwc_460ex.c:1516: error: implicit declaration of function
'ata_sff_qc_issue'
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_error_handler':
drivers/ata/sata_dwc_460ex.c:1545: error: implicit declaration of function
'ata_sff_error_handler'
drivers/ata/sata_dwc_460ex.c: At top level:
drivers/ata/sata_dwc_460ex.c:1564: error: 'ata_sff_port_ops' undeclared
here (not in a function)
drivers/ata/sata_dwc_460ex.c:1577: error: unknown field 'bmdma_setup'
specified in initializer
drivers/ata/sata_dwc_460ex.c:1577: warning: initialization from
incompatible pointer type
drivers/ata/sata_dwc_460ex.c:1578: error: unknown field 'bmdma_start'
specified in initializer
drivers/ata/sata_dwc_460ex.c:1578: warning: initialization from
incompatible pointer type
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_probe':
drivers/ata/sata_dwc_460ex.c:1638: error: 'struct ata_port' has no member
named 'ioaddr'
drivers/ata/sata_dwc_460ex.c:1639: error: 'struct ata_port' has no member
named 'ioaddr'
drivers/ata/sata_dwc_460ex.c:1641: error: 'struct ata_port' has no member
named 'ioaddr'
make[2]: *** [drivers/ata/sata_dwc_460ex.o] Error 1
make[1]: *** [drivers/ata] Error 2
make: *** [drivers] Error 2


Does this require any specific kernel version?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
A direct quote from the Boss: "We passed over a lot of good people to
get the ones we hired."
