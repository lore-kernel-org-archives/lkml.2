Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab0KTFya (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 00:54:30 -0500
Received: from ip-85-135-19-82.customer.poda.cz ([85.135.19.82]:57327 "EHLO
	nik-comp.lan" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750820Ab0KTFy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 00:54:29 -0500
X-Greylist: delayed 27202 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Nov 2010 00:54:29 EST
Date: Fri, 19 Nov 2010 23:18:56 +0100
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        davem@davemloft.net, jesse@nicira.com
Subject: Re: [Stable-review] [00/66] 2.6.36.1-stable review
Message-ID: <20101119221856.GB2095@nik-comp.lan>
References: <20101119220309.GA15562@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Content-Disposition: inline
In-Reply-To: <20101119220309.GA15562@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,
I guess it's certainly quite late for it now, but would You be willing
to accept this one for 2.6.36.1 too?

http://www.spinics.net/lists/netdev/msg146227.html

fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=3D20462

It's been submitted to stable, but for some reason it was omited...
BR
nik



On Fri, Nov 19, 2010 at 02:03:09PM -0800, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.36.1 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
>=20
> Responses should be made by Monday, November 22, 2010, 12:00:00 UTC
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.36.1-rc1.gz
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h
>=20
>=20
>  Makefile                                         |    2 +-
>  arch/arm/include/asm/kgdb.h                      |    5 ++-
>  arch/arm/kernel/kgdb.c                           |    2 +-
>  arch/arm/mach-cns3xxx/include/mach/debug-macro.S |    2 +-
>  arch/powerpc/kernel/ppc970-pmu.c                 |    2 +
>  arch/x86/include/asm/cpufeature.h                |    2 +-
>  arch/x86/include/asm/io.h                        |    1 +
>  arch/x86/include/asm/mrst.h                      |    2 +-
>  arch/x86/include/asm/smp.h                       |    9 ++++-
>  arch/x86/kernel/apic/io_apic.c                   |    2 +
>  arch/x86/kernel/cpu/mtrr/cleanup.c               |    2 +-
>  arch/x86/kernel/cpu/perf_event_amd.c             |    4 +-
>  arch/x86/kernel/crash_dump_64.c                  |    3 +-
>  arch/x86/kernel/olpc.c                           |    5 ++-
>  arch/x86/kernel/reboot.c                         |    2 +-
>  arch/x86/kernel/smp.c                            |   15 +++++---
>  arch/x86/kernel/traps.c                          |    1 +
>  arch/x86/kernel/vm86_32.c                        |   10 ++++-
>  arch/x86/kvm/svm.c                               |   37 ++++++++++++++++=
+++-
>  arch/x86/kvm/x86.c                               |    4 +-
>  arch/x86/xen/enlighten.c                         |    2 +-
>  arch/x86/xen/smp.c                               |    6 ++--
>  drivers/ata/ahci.h                               |    1 +
>  drivers/ata/libahci.c                            |   18 ++++++++--
>  drivers/bluetooth/hci_ldisc.c                    |    7 ++++
>  drivers/char/pcmcia/synclink_cs.c                |    2 +
>  drivers/idle/intel_idle.c                        |    2 +-
>  drivers/misc/sgi-xp/xpc_uv.c                     |   17 +++++++++
>  drivers/net/wireless/p54/eeprom.c                |    4 ++-
>  drivers/net/wireless/p54/p54usb.c                |   15 ++++++++-
>  drivers/platform/x86/asus-laptop.c               |    6 ++--
>  drivers/scsi/gdth.c                              |    8 ++++
>  drivers/scsi/libsas/sas_ata.c                    |    1 +
>  drivers/scsi/pmcraid.h                           |    1 -
>  drivers/scsi/qla4xxx/ql4_nx.c                    |    1 +
>  drivers/scsi/scsi_lib.c                          |    3 +-
>  drivers/scsi/scsi_sysfs.c                        |    3 +-
>  drivers/scsi/sd.c                                |   15 +++++---
>  drivers/staging/phison/phison.c                  |    2 +-
>  drivers/staging/usbip/usbip_event.c              |   16 ++-------
>  drivers/staging/usbip/vhci_hcd.c                 |    2 +
>  drivers/usb/core/hcd-pci.c                       |    4 ++-
>  drivers/usb/core/hub.c                           |    9 +++--
>  drivers/usb/core/message.c                       |   14 ++++----
>  drivers/usb/gadget/atmel_usba_udc.c              |    3 ++
>  drivers/usb/gadget/composite.c                   |    3 +-
>  drivers/usb/gadget/f_acm.c                       |    2 +-
>  drivers/usb/gadget/g_ffs.c                       |    4 +-
>  drivers/usb/gadget/multi.c                       |    4 +-
>  drivers/usb/host/ohci-hcd.c                      |    9 ++++-
>  drivers/usb/host/ohci-pci.c                      |   18 ++++++++++
>  drivers/usb/host/ohci.h                          |    1 +
>  drivers/usb/host/pci-quirks.c                    |   18 ++++++----
>  drivers/usb/host/r8a66597.h                      |    2 +-
>  drivers/usb/musb/blackfin.c                      |    7 +++-
>  drivers/usb/musb/davinci.c                       |    2 +
>  drivers/usb/musb/musb_core.c                     |    4 --
>  drivers/usb/musb/omap2430.c                      |    1 +
>  drivers/usb/musb/tusb6010.c                      |    4 ++
>  drivers/usb/serial/cp210x.c                      |    2 +
>  drivers/usb/serial/ftdi_sio.c                    |   39 ++++++++++++++++=
+++---
>  drivers/usb/serial/ftdi_sio_ids.h                |   39 ++++++++++++++++=
+++++-
>  drivers/usb/serial/mct_u232.c                    |    7 +++-
>  drivers/usb/serial/opticon.c                     |    6 ++--
>  drivers/usb/serial/option.c                      |   23 +++++++++++--
>  drivers/usb/serial/visor.c                       |   11 +++++-
>  fs/cifs/cifsproto.h                              |    3 +-
>  fs/cifs/dir.c                                    |   12 +++----
>  fs/cifs/file.c                                   |    4 +-
>  fs/nfs/direct.c                                  |    2 +-
>  fs/pipe.c                                        |    2 +-
>  kernel/futex.c                                   |   31 +++++++++--------
>  kernel/perf_event.c                              |    8 ++++-
>  kernel/sched.c                                   |   13 ++-----
>  mm/vmalloc.c                                     |    9 +++++
>  net/bluetooth/l2cap.c                            |    4 +-
>  net/netfilter/xt_SECMARK.c                       |    2 +-
>  77 files changed, 420 insertions(+), 150 deletions(-)
>=20
> _______________________________________________
> Stable-review mailing list
> Stable-review@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable-review

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAkzm99AACgkQ3xdJJrLygV5LkACggrdarjluH/t1kzTYIpsSt6j7
qusAoLRFcf6lYUXPsktfWCfZcMYJyT1P
=VqDN
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
