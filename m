Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab0D0IAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 04:00:06 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60465 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab0D0IAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 04:00:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=trqYBpLn9LFMgdTC+O5V7Qp89bSOgbNTDTRhancBycGuCXXemP2sYJDQhED6fTtCg3
         ZJxmtGBSH0cObVrPhc+/kpRTt6j//n7p2HZcW1u9aHsvD4rWlb7sTIRTwvj+EM8WrE0R
         9mgwlNGcnWL5ZSB/CiYdmCTESb3fljvyNQBpY=
Date: Tue, 27 Apr 2010 11:01:19 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Robert Hancock <hancockrwd@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: INFO: umount blocked for more than 120 seconds
Message-ID: <20100427080119.GB3291@swordfish.minsk.epam.com>
References: <20100426090142.GB3704@swordfish.minsk.epam.com>
 <Pine.LNX.4.44L0.1004261534520.1764-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1004261534520.1764-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

Robert Hancock added to Cc list.

First of all, let me describe hw (sorry for skipping this part in prev. ema=
il).
The device is ASUS p535 in a card reader mode. The card is 1Gb MiniSD (King=
ston).


On (04/26/10 15:36), Alan Stern wrote:
> Is this repeatable?
>
Yes.

kernel: [14980.102019] usb 2-1: new full speed USB device using uhci_hcd an=
d address 2
kernel: [14980.270773] usb 2-1: New USB device found, idVendor=3D0b05, idPr=
oduct=3D422f
kernel: [14980.270783] usb 2-1: New USB device strings: Mfr=3D1, Product=3D=
2, SerialNumber=3D3
kernel: [14980.270790] usb 2-1: Product: Generic Mass Storage
kernel: [14980.270797] usb 2-1: Manufacturer: ASUS
kernel: [14980.270803] usb 2-1: SerialNumber: *****************************=
****
kernel: [14980.273767] scsi3 : usb-storage 2-1:1.0
kernel: [14981.279875] scsi scan: INQUIRY result too short (5), using 36
kernel: [14981.279890] scsi 3:0:0:0: Direct-Access                         =
           PQ: 0 ANSI: 0
kernel: [14981.289597] sd 3:0:0:0: Attached scsi generic sg2 type 0
kernel: [14981.301967] sd 3:0:0:0: [sdb] 2012160 512-byte logical blocks: (=
1.03 GB/982 MiB)
kernel: [14981.304760] sd 3:0:0:0: [sdb] Write Protect is off
kernel: [14981.304765] sd 3:0:0:0: [sdb] Mode Sense: 00 06 00 00
kernel: [14981.304768] sd 3:0:0:0: [sdb] Assuming drive cache: write through
kernel: [14981.316864] sd 3:0:0:0: [sdb] Assuming drive cache: write through
kernel: [14981.316877]  sdb: sdb1
kernel: [14981.339861] sd 3:0:0:0: [sdb] Assuming drive cache: write through
kernel: [14981.339873] sd 3:0:0:0: [sdb] Attached SCSI removable disk
kernel: [15014.446419] FAT: utf8 is not a recommended IO charset for FAT fi=
lesystems, filesystem will be case sensitive!
kernel: [15360.625323] INFO: task umount:7148 blocked for more than 120 sec=
onds.
kernel: [15360.625332] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" d=
isables this message.
kernel: [15360.625340] umount        D 00000dd9     0  7148   6292 0x000000=
00
kernel: [15360.625353]  f38bfe38 00000046 12abbd47 00000dd9 c1610cc0 c12c38=
90 c1610cc0 c1610cc0
kernel: [15360.625377]  c1610cc0 c1610cc0 f6fc5790 c1610cc0 00010bbe 000000=
00 12aab189 00000dd9
kernel: [15360.625400]  f6fc5500 f38bfe40 f38bfe70 00000000 f38bfe78 f38bfe=
40 c10b7cf0 f38bfe5c
kernel: [15360.625423] Call Trace:
kernel: [15360.625442]  [<c12c3890>] ? _raw_spin_unlock_irqrestore+0x36/0x5b
kernel: [15360.625457]  [<c10b7cf0>] bdi_sched_wait+0x8/0xc
kernel: [15360.625467]  [<c12c20ef>] __wait_on_bit+0x34/0x5b
kernel: [15360.625477]  [<c10b7ce8>] ? bdi_sched_wait+0x0/0xc
kernel: [15360.625487]  [<c12c216d>] out_of_line_wait_on_bit+0x57/0x5f
kernel: [15360.625497]  [<c10b7ce8>] ? bdi_sched_wait+0x0/0xc
kernel: [15360.625510]  [<c103fa75>] ? wake_bit_function+0x0/0x4d
kernel: [15360.625521]  [<c10b84d4>] wait_on_bit.clone.0+0x17/0x23
kernel: [15360.625531]  [<c10b8544>] sync_inodes_sb+0x64/0x10d
kernel: [15360.625546]  [<c10d373f>] ? vfs_quota_sync+0x0/0x1da
kernel: [15360.625556]  [<c10baef6>] __sync_filesystem+0x37/0x62
kernel: [15360.625566]  [<c10bb062>] sync_filesystem+0x3c/0x3f
kernel: [15360.625578]  [<c10a2def>] generic_shutdown_super+0x1c/0xca
kernel: [15360.625588]  [<c10a2eba>] kill_block_super+0x1d/0x31
kernel: [15360.625599]  [<c10a3833>] deactivate_super+0x48/0x5a
kernel: [15360.625610]  [<c10b385c>] mntput_no_expire+0x5e/0x89
kernel: [15360.625620]  [<c10b41cf>] sys_umount+0x277/0x29b
kernel: [15360.625631]  [<c10b4200>] sys_oldumount+0xd/0xf
kernel: [15360.625642]  [<c1002813>] sysenter_do_call+0x12/0x32
kernel: [15360.625652] 1 lock held by umount/7148:
kernel: [15360.625657]  #0:  (&type->s_umount_key#32){++++..}, at: [<c10a38=
2e>] deactivate_super+0x43/0x5a


> Can you do this with CONFIG_USB_DEBUG enabled?  And acquire a usbmon=20
> trace at the same time (see Documentation/usb/usbmon.txt)?
>=20

Sure. Rebuilding the kernel right now.



Robert Hancock wrote:
> Is this some super-slow SD card or USB reader that you just wrote a bunch=
 of data to?=20
> It's not impossible it could take 2 minutes for the writeout of all the d=
irty data to
> complete on unmount..=20
Please see above.

> did the unmount ever complete?
No entry in /etc/mtab. So, I guess, yes - umount complete.


	Sergey

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkvWmc8ACgkQfKHnntdSXjQcMAP8CYmbOwUS26pOR8KIqxj0a9In
9hwnJQcu/nCZpJsmbYCadnO/QLUpT9yjkEL+8wkYe4NrTT/36JuMWGxFEJ+t7iql
riZUVFXbyZHo5GHmxgFHwJNWzzq0MxcbWRHGnNomkesj8x84if05pp+Gfem5p2zR
ClhZQQbJfe5R8EroghY=
=3d60
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
