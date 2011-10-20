Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab1JTKgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 06:36:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510Ab1JTKgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 06:36:47 -0400
Date: Thu, 20 Oct 2011 12:36:45 +0200
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Subject: [ANNOUNCE] util-linux v2.20.1
Message-ID: <20111020103645.GA1785@nb.net.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


 The bugfix release util-linux 2.20.1 is available at

   ftp://ftp.infradead.org/pub/util-linux/v2.20/

 Feedback and bug reports, as always, are welcomed.

=20
 Please note that infradead.org is temporary location for the upstream
 tarballs and https://github.com/karelzak/util-linux is temporary
 location for the upstream git tree. I hope that whole FTP with all
 util-linux history will be restored at kernel.org.

 For all official stuff (tags, tarballs and announces) I use a new GPG
 key (id EC39C284).

       Karel


util-linux 2.20.1 Release Notes
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

Changes since v2.20
-------------------

 For more details see ChangeLog files at:
 ftp://ftp.infradead.org/pub/util-linux/v2.20/


agetty:
   - double equals sign typo in opentty()  [Karel Zak]
   - test ECHO on c_lflag  [Karel Zak]
blkid:
   - fix unfinished sentence for -l option in blkid.8  [Dave Reisner]
   - potential null derefence [smatch scan]  [Karel Zak]
build-sys:
   - check scanf %ms modifier  [Karel Zak]
   - ddate typo fixed  [Sami Kerola]
   - don't install ru/ddate.1 if ddate disabled  [Karel Zak]
   - remove redundant __progname check  [Karel Zak]
   - rename BUILD_BUG_ON_ZERO definition  [Sami Kerola]
dmesg:
   - fix for non-CONFIG_PRINTK_TIME kernels  [Karel Zak]
   - remove extra space only after time stamp  [Karel Zak]
docs:
   - update AUTHORS file  [Karel Zak]
fdformat:
   - fix uninitialized variable  [Francesco Cosoleto]
fdisk:
   - don't shorten long path to disk device  [Karel Zak]
flock:
   - make flock(1) work on NFSv4  [Michal Kubecek]
fstrim:
   - fix section number in referral to manpage  [Petr Uzel]
include,c.h:
   - include fcntl.h before check for O_CLOEXEC [smatch scan]  [Karel Zak]
include,xalloc:
   - check for NULL before calling strdup  [Dave Reisner]
kill:
   - potential null derefence [smatch scan]  [Karel Zak]
lib:
   - do not attempt to close(0) in sysfs_deinit()  [Petr Uzel]
lib,loopdev:
   - fix use of logical '&&' with constant operand  [Francesco Cosoleto]
libmount:
   - fix use of logical '&&' with constant operand  [Francesco Cosoleto]
   - potential null derefence [smatch scan]  [Karel Zak]
   - redundant null check on calling free() [smatch scan]  [Karel Zak]
   - unable to umount nfs shares using the force option  [Karel Zak]
   - use unsigned int for bitfields [smatch scan]  [Karel Zak]
   - variable dereferenced before check [smatch scan]  [Karel Zak]
libuuid:
   - add limits.h include for OPEN_MAX  [maximilian attems]
lscpu:
   - allow read_cache() to be called for offline cpus  [Heiko Carstens]
   - fix cache output for extended parsable output  [Heiko Carstens]
   - fix cpu map array sizes  [Heiko Carstens]
   - fix fallback nthreads calculation  [Heiko Carstens]
   - fix s390 bogomips detection coding style  [Heiko Carstens]
   - remove comma operator  [Heiko Carstens]
   - simplify cache column output function  [Heiko Carstens]
   - use hypervisor generated topology information  [Heiko Carstens]
mount:
   - check for target before source on remount  [Karel Zak]
   - remounting tmpfs read-write hangs (selinux)  [Karel Zak]
   - remove superfluous "an" under ext4 mount options in mount.8  [Frederik=
 \"Freso\" S. Olesen]
mountpoint:
   - fallback on stat when /proc isn't mounted  [Karel Zak]
   - return dev_t from dir_to_device  [Dave Reisner]
   - support symbolic and relative paths  [Karel Zak]
po:
   - merge changes  [Karel Zak]
   - update ja.po (from translationproject.org)  [Takeshi Hamasaki]
raw:
   - fix shadowing of minor function  [maximilian attems]
rtcwake:
   - fix crash (invalid free)  [Petr Uzel]
script:
   - fix building with --disable-nls  [Natanael Copa]
sfdisk:
   - file descriptor is of int type  [Petr Uzel]
   - get_disksize() returns long long  [Petr Uzel]
   - introduce get_ull() function  [Petr Uzel]
   - make the cylinder boundary check less fatal  [Petr Uzel]
   - sfdisk.8 fix formatting  [Petr Uzel]
   - use unsigned long long to internally represent sector number  [Petr Uz=
el]
switch_root:
   - handle /run and do not mount over existing mounts
uuidd:
   - Add missing break to option case statement  [Eric Sandeen]
write:
   - fix path for freopen()  [Karel Zak]
--=20
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOn/m9AAoJEOS3HV7sOcKE7+UP/3V8yY6bEqagI+n5YKTiuqGU
SwWsMCv3J87uKmqB+EWTV3NSvYHeRh3fa9OMZxnfpG5+/1Xs/DTNJp/AGEFbHn8+
3kNT4npD41nY/GHASNT/jcepCc1gf3o8+/jte6mn1Ltdc3GJ7kEHGmj0dAUTffjn
D2XraGpe+44J98p9Z/yiwoo2BGiM4VCclF79Jwb8aZZktVPMy+c2yY/yGEqDk4c6
T4osKEX9h+tZW3FVAgM0X77D+F9YL0CGo1J6rJRt9hS3KUKtYhhYPlcyLXSPoB8z
jKSaWmI4PG11aQ60dgShpSJtI1F/ggul0hGqBH+arrF32pfzO+lBosQJB3b6Vpxl
Rdtjy4hDNIQ+VO2GTLVHwDBfnfJttob59mVSqJgIdCE2nXdh5xCgELCUWMDiuCYr
CLf2R/lwLLhONiOSUeqYAZRXZwNlS5LLDe0VEEUbyek2tp3kgjQPWfuAM9QqdhqB
nZ8lx41yYZz8r/5Up9spqVModWwqiIMWPapOhoX9t3xE4K8pYMXBQq5UXR1cOSAO
6eMEKTCzx183qOpVuMPERpviMOFpbQiCN2+NUmyQZGtoSXMp9ElX7gMRBv6hJvYj
WNwcdNmgpS8jpKGOpF5ZA6hH01MFTBSwEp6jqRTIURToFe6MTlym60iJLAkE+51H
EJ3QsX4gZyTEpmaPdlDN
=QbEG
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
