Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab0G1GFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 02:05:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50827 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab0G1GFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 02:05:38 -0400
Date: Wed, 28 Jul 2010 16:05:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vikas Chaudhary <vikas.chaudhary@qlogic.com>,
        Karen Higgins <karen.higgins@qlogic.com>,
        Ravi Anand <ravi.anand@qlogic.com>
Subject: linux-next: build failure after merge of the final tree (scsi tree
 related)
Message-Id: <20100728160530.da25fdb1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Jul_2010_16_05_30_+1000_Gs1NXlXmplBYbcTk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Jul_2010_16_05_30_+1000_Gs1NXlXmplBYbcTk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/scsi/qla4xxx/built-in.o: In function `.qla82xx_wr_32':
(.text+0x183d0): multiple definition of `.qla82xx_wr_32'
drivers/scsi/qla2xxx/built-in.o:(.text+0x74630): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `.qla82xx_device_state_handler=
':
(.text+0x1d2b0): multiple definition of `.qla82xx_device_state_handler'
drivers/scsi/qla2xxx/built-in.o:(.text+0x7cf00): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_idc_unlock':
(.opd+0xbe8): multiple definition of `qla82xx_idc_unlock'
drivers/scsi/qla2xxx/built-in.o:(.opd+0x2fb8): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `.qla82xx_clear_drv_active':
(.text+0x1a490): multiple definition of `.qla82xx_clear_drv_active'
drivers/scsi/qla2xxx/built-in.o:(.text+0x76d04): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_pci_config':
(.opd+0x630): multiple definition of `qla82xx_pci_config'
drivers/scsi/qla2xxx/built-in.o:(.opd+0x2e98): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `.qla82xx_pci_mem_write_2M':
(.text+0x1c12c): multiple definition of `.qla82xx_pci_mem_write_2M'
drivers/scsi/qla2xxx/built-in.o:(.text+0x79620): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `.qla82xx_pci_get_crb_addr_2M':
(.text+0x16e4c): multiple definition of `.qla82xx_pci_get_crb_addr_2M'
drivers/scsi/qla2xxx/built-in.o:(.text+0x71944): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `.qla82xx_watchdog':
(.text+0x49d8): multiple definition of `.qla82xx_watchdog'
drivers/scsi/qla2xxx/built-in.o:(.text+0x74db8): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_pci_mem_write_2M':
(.opd+0xdf8): multiple definition of `qla82xx_pci_mem_write_2M'
drivers/scsi/qla2xxx/built-in.o:(.opd+0x3150): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_pci_get_crb_addr_2M':
(.opd+0xb28): multiple definition of `qla82xx_pci_get_crb_addr_2M'
drivers/scsi/qla2xxx/built-in.o:(.opd+0x2ce8): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_wr_32':
(.opd+0xc48): multiple definition of `qla82xx_wr_32'
drivers/scsi/qla2xxx/built-in.o:(.opd+0x2ef8): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_pci_mem_read_2M':
(.opd+0xde0): multiple definition of `qla82xx_pci_mem_read_2M'
drivers/scsi/qla2xxx/built-in.o:(.opd+0x3138): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_msix_rsp_q':
(.opd+0xa68): multiple definition of `qla82xx_msix_rsp_q'
drivers/scsi/qla2xxx/built-in.o:(.opd+0x2e50): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `.qla82xx_iospace_config':
(.text+0x4424): multiple definition of `.qla82xx_iospace_config'
drivers/scsi/qla2xxx/built-in.o:(.text+0x740b4): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_rd_32':
(.opd+0xbb8): multiple definition of `qla82xx_rd_32'
drivers/scsi/qla2xxx/built-in.o:(.opd+0x2f28): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `.qla82xx_idc_lock':
(.text+0x18030): multiple definition of `.qla82xx_idc_lock'
drivers/scsi/qla2xxx/built-in.o:(.text+0x7c464): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `.qla82xx_crb_win_lock':
(.text+0x18228): multiple definition of `.qla82xx_crb_win_lock'
drivers/scsi/qla2xxx/built-in.o:(.text+0x74824): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `.qla82xx_msix_rsp_q':
(.text+0x15c70): multiple definition of `.qla82xx_msix_rsp_q'
drivers/scsi/qla2xxx/built-in.o:(.text+0x72f80): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_watchdog':
(.opd+0x378): multiple definition of `qla82xx_watchdog'
drivers/scsi/qla2xxx/built-in.o:(.opd+0x2f58): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `.qla82xx_load_risc':
(.text+0x1d938): multiple definition of `.qla82xx_load_risc'
drivers/scsi/qla2xxx/built-in.o:(.text+0x7d44c): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `.qla82xx_disable_intrs':
(.text+0x185b8): multiple definition of `.qla82xx_disable_intrs'
drivers/scsi/qla2xxx/built-in.o:(.text+0x76b20): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_load_risc':
(.opd+0xeb8): multiple definition of `qla82xx_load_risc'
drivers/scsi/qla2xxx/built-in.o:(.opd+0x3390): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_crb_win_lock':
(.opd+0xc30): multiple definition of `qla82xx_crb_win_lock'
drivers/scsi/qla2xxx/built-in.o:(.opd+0x2f10): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_intr_handler':
(.opd+0xac8): multiple definition of `qla82xx_intr_handler'
drivers/scsi/qla2xxx/built-in.o:(.opd+0x3048): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_clear_drv_active':
(.opd+0xd50): multiple definition of `qla82xx_clear_drv_active'
drivers/scsi/qla2xxx/built-in.o:(.opd+0x3030): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `.qla82xx_enable_intrs':
(.text+0x187c0): multiple definition of `.qla82xx_enable_intrs'
drivers/scsi/qla2xxx/built-in.o:(.text+0x76c10): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_disable_intrs':
(.opd+0xc60): multiple definition of `qla82xx_disable_intrs'
drivers/scsi/qla2xxx/built-in.o:(.opd+0x3000): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_iospace_config':
(.opd+0x330): multiple definition of `qla82xx_iospace_config'
drivers/scsi/qla2xxx/built-in.o:(.opd+0x2eb0): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `.qla82xx_rd_32':
(.text+0x17b84): multiple definition of `.qla82xx_rd_32'
drivers/scsi/qla2xxx/built-in.o:(.text+0x74934): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `.qla82xx_pci_mem_read_2M':
(.text+0x1bbd0): multiple definition of `.qla82xx_pci_mem_read_2M'
drivers/scsi/qla2xxx/built-in.o:(.text+0x790c8): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_enable_intrs':
(.opd+0xc78): multiple definition of `qla82xx_enable_intrs'
drivers/scsi/qla2xxx/built-in.o:(.opd+0x3018): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_device_state_handler':
(.opd+0xe88): multiple definition of `qla82xx_device_state_handler'
drivers/scsi/qla2xxx/built-in.o:(.opd+0x3378): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `.qla82xx_idc_unlock':
(.text+0x17fbc): multiple definition of `.qla82xx_idc_unlock'
drivers/scsi/qla2xxx/built-in.o:(.text+0x752cc): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `.qla82xx_intr_handler':
(.text+0x1653c): multiple definition of `.qla82xx_intr_handler'
drivers/scsi/qla2xxx/built-in.o:(.text+0x76db4): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `.qla82xx_pci_config':
(.text+0xbd78): multiple definition of `.qla82xx_pci_config'
drivers/scsi/qla2xxx/built-in.o:(.text+0x74010): first defined here
drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_idc_lock':
(.opd+0xc00): multiple definition of `qla82xx_idc_lock'
drivers/scsi/qla2xxx/built-in.o:(.opd+0x3318): first defined here

Caused by commit 4a60a4e243daf9e47487adbd1be1f816c95f57d0 ("[SCSI]
qla4xxx: Added support for ISP82XX").

I have left this broken for today.  Please fix it up ASAP.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Jul_2010_16_05_30_+1000_Gs1NXlXmplBYbcTk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMT8iqAAoJEDMEi1NhKgbsL4IH/R8DkZ2MRRseIXfpEUedbgt0
9Enh7uDnRMLuFVyBZ/+wWom24XgGwt0PuAYo94HwHDvTCiaqElbrpTdTZAcdbkQj
ZSouKxeDdV6i/EmHNK76l88bjUzwDH6qkSzjBE5nrsPE8GYHG44+zkMln7zkeAC6
/X+4dkQ0yWLBi8NSvN1ofBNQ9ji0k8ijYMOMkj2p4gPUkfPN7YujNw9dlUkFEzRe
LFa3mpdp2s54K7LPLFeNBcRRniOcjpZY3LlvwXfiD0SMnQD5Qx94lR5AgHfqRuEP
99nKAiWGFN7UbCMIdcYU9UaxUEEMXA9elZz3KBqd/zAQI974UEkVc8DOLtD7olQ=
=8o7l
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Jul_2010_16_05_30_+1000_Gs1NXlXmplBYbcTk--
