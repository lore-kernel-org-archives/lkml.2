Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0L3BWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 20:22:24 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59859 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0L3BWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 20:22:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-pgp-agent
         :x-mailer;
        b=Z0p7om5L8dKCjqB98uhOvr7eG2wQLUvTPWS1Yq5cWeiNhwFXcQuAjpfGtPXkuf4xNN
         rwIMaL6Fjc2s9tHu6horGHi6JU4xaiTfwgdULqyhCl1scTJQ/ZO1MRJXV7sKPlOvi/Fv
         SUjtAgJVYeqRIeEcdXJHuzL/oiSFvttVtv5TM=
Subject: Re: linux-next: manual merge of the alacrity tree with the  tree
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-6--315157671"
From: Gregory Haskins <gregory.haskins@gmail.com>
In-Reply-To: <20101230114332.c19ba13b.sfr@canb.auug.org.au>
Date: Wed, 29 Dec 2010 20:22:18 -0500
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3FCD0DDB-EDC6-4CF2-A5A9-5C93DBA624AA@gmail.com>
References: <20101230114332.c19ba13b.sfr@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
X-Pgp-Agent: GPGMail 1.3.1
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-6--315157671
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=us-ascii

Hi Stephen,

On Dec 29, 2010, at 7:43 PM, Stephen Rothwell wrote:

> Hi Gregory,
>=20
> Today's linux-next merge of the alacrity tree got a conflict in
> include/linux/Kbuild between various commits from various trees and
> various commits from the alacrity tree.
>=20
> I fixed it up (again - see below).  I must ask, though, since the =
commits
> in the alacrity tree have been there since May, is there is any =
progress
> towards getting them integrated into Llinus' tree?

Sorry about all that.  I haven't had a chance to play with that code =
base for a while and the requisite demand Linus was looking for hasn't =
been very vocal.  I'd say just drop my tree for now if its a nuisance, =
and I will re-post it to you once I have a chance to give it some love.

Thanks,
-Greg

> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc include/linux/Kbuild
> index 2296d8b,1a31099..0000000
> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@@ -128,106 -70,43 +128,107 @@@ header-y +=3D fd.
>  header-y +=3D fdreg.h
>  header-y +=3D fib_rules.h
>  header-y +=3D fiemap.h
> +header-y +=3D filter.h
>  header-y +=3D firewire-cdev.h
>  header-y +=3D firewire-constants.h
> +header-y +=3D flat.h
> +header-y +=3D fs.h
>  header-y +=3D fuse.h
> -header-y +=3D genetlink.h
> +header-y +=3D futex.h
> +header-y +=3D gameport.h
>  header-y +=3D gen_stats.h
> +header-y +=3D generic_serial.h
> +header-y +=3D genetlink.h
>  header-y +=3D gfs2_ondisk.h
>  header-y +=3D gigaset_dev.h
> +header-y +=3D hdlc.h
> +header-y +=3D hdlcdrv.h
> +header-y +=3D hdreg.h
> +header-y +=3D hid.h
> +header-y +=3D hiddev.h
> +header-y +=3D hidraw.h
> +header-y +=3D hpet.h
>  header-y +=3D hysdn_if.h
> +header-y +=3D i2c-dev.h
> +header-y +=3D i2c.h
>  header-y +=3D i2o-dev.h
>  header-y +=3D i8k.h
> +header-y +=3D icmp.h
> +header-y +=3D icmpv6.h
> +header-y +=3D if.h
> +header-y +=3D if_addr.h
>  header-y +=3D if_addrlabel.h
> +header-y +=3D if_alg.h
>  header-y +=3D if_arcnet.h
> +header-y +=3D if_arp.h
>  header-y +=3D if_bonding.h
> +header-y +=3D if_bridge.h
>  header-y +=3D if_cablemodem.h
> +header-y +=3D if_ec.h
> +header-y +=3D if_eql.h
> +header-y +=3D if_ether.h
>  header-y +=3D if_fc.h
> -header-y +=3D if.h
> +header-y +=3D if_fddi.h
> +header-y +=3D if_frad.h
>  header-y +=3D if_hippi.h
>  header-y +=3D if_infiniband.h
> +header-y +=3D if_link.h
> +header-y +=3D if_ltalk.h
>  header-y +=3D if_packet.h
> +header-y +=3D if_phonet.h
>  header-y +=3D if_plip.h
>  header-y +=3D if_ppp.h
> +header-y +=3D if_pppol2tp.h
> +header-y +=3D if_pppox.h
>  header-y +=3D if_slip.h
>  header-y +=3D if_strip.h
> +header-y +=3D if_tr.h
>  header-y +=3D if_tun.h
> +header-y +=3D if_tunnel.h
> +header-y +=3D if_vlan.h
> +header-y +=3D if_x25.h
> +header-y +=3D igmp.h
> +header-y +=3D in.h
> +header-y +=3D in6.h
>  header-y +=3D in_route.h
> +header-y +=3D inet_diag.h
> +header-y +=3D inotify.h
> +header-y +=3D input.h
>  header-y +=3D ioctl.h
> ++header-y +=3D ioq.h
> +header-y +=3D ip.h
>  header-y +=3D ip6_tunnel.h
> +header-y +=3D ip_vs.h
> +header-y +=3D ipc.h
> +header-y +=3D ipmi.h
>  header-y +=3D ipmi_msgdefs.h
>  header-y +=3D ipsec.h
> -header-y +=3D ip_vs.h
> +header-y +=3D ipv6.h
> +header-y +=3D ipv6_route.h
>  header-y +=3D ipx.h
>  header-y +=3D irda.h
> +header-y +=3D irqnr.h
> +header-y +=3D isdn.h
> +header-y +=3D isdn_divertif.h
> +header-y +=3D isdn_ppp.h
> +header-y +=3D isdnif.h
>  header-y +=3D iso_fs.h
> +header-y +=3D ivtv.h
> +header-y +=3D ivtvfb.h
>  header-y +=3D ixjuser.h
>  header-y +=3D jffs2.h
> +header-y +=3D joystick.h
> +header-y +=3D kd.h
> +header-y +=3D kdev_t.h
> +header-y +=3D kernel.h
> +header-y +=3D kernelcapi.h
> +header-y +=3D keyboard.h
>  header-y +=3D keyctl.h
> +header-y +=3D l2tp.h
>  header-y +=3D limits.h
> +header-y +=3D llc.h
> +header-y +=3D loop.h
> +header-y +=3D lp.h
>  header-y +=3D magic.h
>  header-y +=3D major.h
>  header-y +=3D map_to_7segment.h
> @@@ -290,104 -136,259 +291,107 @@@ header-y +=3D phantom.
>  header-y +=3D phonet.h
>  header-y +=3D pkt_cls.h
>  header-y +=3D pkt_sched.h
> +header-y +=3D pktcdvd.h
> +header-y +=3D pmu.h
> +header-y +=3D poll.h
>  header-y +=3D posix_types.h
>  header-y +=3D ppdev.h
> +header-y +=3D ppp-comp.h
> +header-y +=3D ppp_defs.h
> +header-y +=3D pps.h
>  header-y +=3D prctl.h
> -header-y +=3D qnxtypes.h
> +header-y +=3D ptrace.h
>  header-y +=3D qnx4_fs.h
> +header-y +=3D qnxtypes.h
> +header-y +=3D quota.h
>  header-y +=3D radeonfb.h
> +header-y +=3D random.h
>  header-y +=3D raw.h
> +header-y +=3D rds.h
> +header-y +=3D reboot.h
> +header-y +=3D reiserfs_fs.h
> +header-y +=3D reiserfs_xattr.h
>  header-y +=3D resource.h
> +header-y +=3D rfkill.h
>  header-y +=3D romfs_fs.h
>  header-y +=3D rose.h
> +header-y +=3D route.h
> +header-y +=3D rtc.h
> +header-y +=3D rtnetlink.h
> +header-y +=3D scc.h
> +header-y +=3D sched.h
> +header-y +=3D screen_info.h
> +header-y +=3D sdla.h
> +header-y +=3D securebits.h
> +header-y +=3D selinux_netlink.h
> +header-y +=3D sem.h
> +header-y +=3D serial.h
> +header-y +=3D serial_core.h
>  header-y +=3D serial_reg.h
> -header-y +=3D smbno.h
> +header-y +=3D serio.h
> +header-y +=3D shm.h
> ++header-y +=3D shm_signal.h
> +header-y +=3D signal.h
> +header-y +=3D signalfd.h
>  header-y +=3D snmp.h
> +header-y +=3D socket.h
>  header-y +=3D sockios.h
>  header-y +=3D som.h
> +header-y +=3D sonet.h
> +header-y +=3D sonypi.h
>  header-y +=3D sound.h
> +header-y +=3D soundcard.h
> +header-y +=3D stat.h
> +header-y +=3D stddef.h
> +header-y +=3D string.h
>  header-y +=3D suspend_ioctls.h
> +header-y +=3D swab.h
> +header-y +=3D synclink.h
> +header-y +=3D sysctl.h
>  header-y +=3D taskstats.h
> +header-y +=3D tcp.h
>  header-y +=3D telephony.h
>  header-y +=3D termios.h
> +header-y +=3D time.h
>  header-y +=3D times.h
> +header-y +=3D timex.h
>  header-y +=3D tiocl.h
>  header-y +=3D tipc.h
>  header-y +=3D tipc_config.h
>  header-y +=3D toshiba.h
> +header-y +=3D tty.h
> +header-y +=3D types.h
>  header-y +=3D udf_fs_i.h
> +header-y +=3D udp.h
> +header-y +=3D uinput.h
> +header-y +=3D uio.h
>  header-y +=3D ultrasound.h
>  header-y +=3D un.h
> +header-y +=3D unistd.h
> +header-y +=3D usbdevice_fs.h
>  header-y +=3D utime.h
> +header-y +=3D utsname.h
> ++header-y +=3D vbus_pci.h
> ++header-y +=3D venet.h
>  header-y +=3D veth.h
> -header-y +=3D videotext.h
> -header-y +=3D x25.h
> -
> -unifdef-y +=3D acct.h
> -unifdef-y +=3D adb.h
> -unifdef-y +=3D adfs_fs.h
> -unifdef-y +=3D agpgart.h
> -ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
> -      		  $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
> -unifdef-y +=3D a.out.h
> -endif
> -unifdef-y +=3D apm_bios.h
> -unifdef-y +=3D atalk.h
> -unifdef-y +=3D atmdev.h
> -unifdef-y +=3D atm.h
> -unifdef-y +=3D atm_tcp.h
> -unifdef-y +=3D audit.h
> -unifdef-y +=3D auto_fs.h
> -unifdef-y +=3D auxvec.h
> -unifdef-y +=3D binfmts.h
> -unifdef-y +=3D blktrace_api.h
> -unifdef-y +=3D capability.h
> -unifdef-y +=3D capi.h
> -unifdef-y +=3D cciss_ioctl.h
> -unifdef-y +=3D cdrom.h
> -unifdef-y +=3D cm4000_cs.h
> -unifdef-y +=3D cn_proc.h
> -unifdef-y +=3D coda.h
> -unifdef-y +=3D connector.h
> -unifdef-y +=3D cuda.h
> -unifdef-y +=3D cyclades.h
> -unifdef-y +=3D dccp.h
> -unifdef-y +=3D dlm.h
> -unifdef-y +=3D dlm_plock.h
> -unifdef-y +=3D edd.h
> -unifdef-y +=3D elf.h
> -unifdef-y +=3D elfcore.h
> -unifdef-y +=3D errno.h
> -unifdef-y +=3D errqueue.h
> -unifdef-y +=3D ethtool.h
> -unifdef-y +=3D eventpoll.h
> -unifdef-y +=3D signalfd.h
> -unifdef-y +=3D ext2_fs.h
> -unifdef-y +=3D fb.h
> -unifdef-y +=3D fcntl.h
> -unifdef-y +=3D filter.h
> -unifdef-y +=3D flat.h
> -unifdef-y +=3D futex.h
> -unifdef-y +=3D fs.h
> -unifdef-y +=3D gameport.h
> -unifdef-y +=3D generic_serial.h
> -unifdef-y +=3D hdlcdrv.h
> -unifdef-y +=3D hdlc.h
> -unifdef-y +=3D hdreg.h
> -unifdef-y +=3D hid.h
> -unifdef-y +=3D hiddev.h
> -unifdef-y +=3D hidraw.h
> -unifdef-y +=3D hpet.h
> -unifdef-y +=3D i2c.h
> -unifdef-y +=3D i2c-dev.h
> -unifdef-y +=3D icmp.h
> -unifdef-y +=3D icmpv6.h
> -unifdef-y +=3D if_addr.h
> -unifdef-y +=3D if_arp.h
> -unifdef-y +=3D if_bridge.h
> -unifdef-y +=3D if_ec.h
> -unifdef-y +=3D if_eql.h
> -unifdef-y +=3D if_ether.h
> -unifdef-y +=3D if_fddi.h
> -unifdef-y +=3D if_frad.h
> -unifdef-y +=3D if_ltalk.h
> -unifdef-y +=3D if_link.h
> -unifdef-y +=3D if_phonet.h
> -unifdef-y +=3D if_pppol2tp.h
> -unifdef-y +=3D if_pppox.h
> -unifdef-y +=3D if_tr.h
> -unifdef-y +=3D if_tunnel.h
> -unifdef-y +=3D if_vlan.h
> -unifdef-y +=3D igmp.h
> -unifdef-y +=3D inet_diag.h
> -unifdef-y +=3D in.h
> -unifdef-y +=3D in6.h
> -unifdef-y +=3D inotify.h
> -unifdef-y +=3D input.h
> -unifdef-y +=3D ioq.h
> -unifdef-y +=3D ip.h
> -unifdef-y +=3D ipc.h
> -unifdef-y +=3D ipmi.h
> -unifdef-y +=3D ipv6.h
> -unifdef-y +=3D ipv6_route.h
> -unifdef-y +=3D isdn.h
> -unifdef-y +=3D isdnif.h
> -unifdef-y +=3D isdn_divertif.h
> -unifdef-y +=3D isdn_ppp.h
> -unifdef-y +=3D ivtv.h
> -unifdef-y +=3D ivtvfb.h
> -unifdef-y +=3D joystick.h
> -unifdef-y +=3D kdev_t.h
> -unifdef-y +=3D kd.h
> -unifdef-y +=3D kernelcapi.h
> -unifdef-y +=3D kernel.h
> -unifdef-y +=3D keyboard.h
> -ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
> -      		  $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
> -unifdef-y +=3D kvm.h
> -endif
> -ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
> -		  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
> -unifdef-y +=3D kvm_para.h
> -endif
> -unifdef-y +=3D llc.h
> -unifdef-y +=3D loop.h
> -unifdef-y +=3D lp.h
> -unifdef-y +=3D mempolicy.h
> -unifdef-y +=3D mii.h
> -unifdef-y +=3D mman.h
> -unifdef-y +=3D mroute.h
> -unifdef-y +=3D mroute6.h
> -unifdef-y +=3D msdos_fs.h
> -unifdef-y +=3D msg.h
> -unifdef-y +=3D nbd.h
> -unifdef-y +=3D ncp_fs.h
> -unifdef-y +=3D ncp.h
> -unifdef-y +=3D ncp_mount.h
> -unifdef-y +=3D netdevice.h
> -unifdef-y +=3D netfilter_bridge.h
> -unifdef-y +=3D netfilter_decnet.h
> -unifdef-y +=3D netfilter.h
> -unifdef-y +=3D netfilter_ipv4.h
> -unifdef-y +=3D netfilter_ipv6.h
> -unifdef-y +=3D net.h
> -unifdef-y +=3D netlink.h
> -unifdef-y +=3D nfs3.h
> -unifdef-y +=3D nfs4.h
> -unifdef-y +=3D nfsacl.h
> -unifdef-y +=3D nfs_fs.h
> -unifdef-y +=3D nfs.h
> -unifdef-y +=3D nfs_idmap.h
> -unifdef-y +=3D n_r3964.h
> -unifdef-y +=3D nubus.h
> -unifdef-y +=3D nvram.h
> -unifdef-y +=3D oom.h
> -unifdef-y +=3D parport.h
> -unifdef-y +=3D patchkey.h
> -unifdef-y +=3D pci.h
> -unifdef-y +=3D personality.h
> -unifdef-y +=3D pktcdvd.h
> -unifdef-y +=3D pmu.h
> -unifdef-y +=3D poll.h
> -unifdef-y +=3D ppp_defs.h
> -unifdef-y +=3D ppp-comp.h
> -unifdef-y +=3D pps.h
> -unifdef-y +=3D ptrace.h
> -unifdef-y +=3D quota.h
> -unifdef-y +=3D random.h
> -unifdef-y +=3D rfkill.h
> -unifdef-y +=3D irqnr.h
> -unifdef-y +=3D reboot.h
> -unifdef-y +=3D reiserfs_fs.h
> -unifdef-y +=3D reiserfs_xattr.h
> -unifdef-y +=3D route.h
> -unifdef-y +=3D rtc.h
> -unifdef-y +=3D rtnetlink.h
> -unifdef-y +=3D scc.h
> -unifdef-y +=3D sched.h
> -unifdef-y +=3D screen_info.h
> -unifdef-y +=3D sdla.h
> -unifdef-y +=3D securebits.h
> -unifdef-y +=3D selinux_netlink.h
> -unifdef-y +=3D sem.h
> -unifdef-y +=3D serial_core.h
> -unifdef-y +=3D serial.h
> -unifdef-y +=3D serio.h
> -unifdef-y +=3D shm.h
> -unifdef-y +=3D shm_signal.h
> -unifdef-y +=3D signal.h
> -unifdef-y +=3D smb_fs.h
> -unifdef-y +=3D smb.h
> -unifdef-y +=3D smb_mount.h
> -unifdef-y +=3D socket.h
> -unifdef-y +=3D sonet.h
> -unifdef-y +=3D sonypi.h
> -unifdef-y +=3D soundcard.h
> -unifdef-y +=3D stat.h
> -unifdef-y +=3D stddef.h
> -unifdef-y +=3D string.h
> -unifdef-y +=3D swab.h
> -unifdef-y +=3D synclink.h
> -unifdef-y +=3D sysctl.h
> -unifdef-y +=3D tcp.h
> -unifdef-y +=3D time.h
> -unifdef-y +=3D timex.h
> -unifdef-y +=3D tty.h
> -unifdef-y +=3D types.h
> -unifdef-y +=3D udp.h
> -unifdef-y +=3D uinput.h
> -unifdef-y +=3D uio.h
> -unifdef-y +=3D unistd.h
> -unifdef-y +=3D usbdevice_fs.h
> -unifdef-y +=3D utsname.h
> -unifdef-y +=3D vhost.h
> -unifdef-y +=3D vbus_pci.h
> -unifdef-y +=3D venet.h
> -unifdef-y +=3D videodev2.h
> -unifdef-y +=3D videodev.h
> -unifdef-y +=3D virtio_config.h
> -unifdef-y +=3D virtio_ids.h
> -unifdef-y +=3D virtio_blk.h
> -unifdef-y +=3D virtio_net.h
> -unifdef-y +=3D virtio_9p.h
> -unifdef-y +=3D virtio_balloon.h
> -unifdef-y +=3D virtio_console.h
> -unifdef-y +=3D virtio_pci.h
> -unifdef-y +=3D virtio_ring.h
> -unifdef-y +=3D virtio_rng.h
> -unifdef-y +=3D vt.h
> -unifdef-y +=3D wait.h
> -unifdef-y +=3D wanrouter.h
> -unifdef-y +=3D watchdog.h
> -unifdef-y +=3D wireless.h
> -unifdef-y +=3D xattr.h
> -unifdef-y +=3D xfrm.h
> -
> -objhdr-y +=3D version.h
> +header-y +=3D vhost.h
> +header-y +=3D videodev2.h
> +header-y +=3D virtio_9p.h
> +header-y +=3D virtio_balloon.h
> +header-y +=3D virtio_blk.h
> +header-y +=3D virtio_config.h
> +header-y +=3D virtio_console.h
> +header-y +=3D virtio_ids.h
> +header-y +=3D virtio_net.h
> +header-y +=3D virtio_pci.h
> +header-y +=3D virtio_ring.h
> +header-y +=3D virtio_rng.h
> +header-y +=3D vt.h
> +header-y +=3D wait.h
> +header-y +=3D wanrouter.h
> +header-y +=3D watchdog.h
>  header-y +=3D wimax.h
> -header-y +=3D wimax/
> +header-y +=3D wireless.h
> +header-y +=3D x25.h
> +header-y +=3D xattr.h
> +header-y +=3D xfrm.h


--Apple-Mail-6--315157671
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.14 (Darwin)

iEYEARECAAYFAk0b3soACgkQP5K2CMvXmqFiRACfT11qKdsiU3m/7kgwOJ7M8kN0
dAwAn2vJbc/iF3fNG0+V3z+tNFjTVTIw
=0E78
-----END PGP SIGNATURE-----

--Apple-Mail-6--315157671--
