Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab2KLKW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 05:22:56 -0500
Received: from mail.agmk.net ([91.192.224.71]:43845 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab2KLKWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 05:22:53 -0500
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, arekm@pld-linux.org,
        baggins@pld-linux.org
Subject: Re: [3.6.6] panic on reboot / khungtaskd blocked? (WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule)
Date: Mon, 12 Nov 2012 11:22:47 +0100
Message-ID: <1539324.MIArxLN8tE@pawels>
User-Agent: KMail/4.9.1 (Linux/3.6.6; KDE/4.9.2; x86_64; ; )
In-Reply-To: <50A0A7EF.3050706@linux.vnet.ibm.com>
References: <56378024.A3Kec8xZj0@pawels> <14708876.P7cyvF6HsA@localhost> <50A0A7EF.3050706@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1625853.miIFPt18EW"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart1625853.miIFPt18EW
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Monday 12 of November 2012 15:40:31 Michael Wang wrote:
> On 11/12/2012 03:16 PM, Pawe=C5=82 Sikora wrote:
> > On Monday 12 of November 2012 11:04:12 Michael Wang wrote:
> >> On 11/09/2012 09:48 PM, Pawe=C5=82 Sikora wrote:
> >>> Hi,
> >>>
> >>> during playing with new ups i've caught an nice oops on reboot:
> >>>
> >>> http://imgbin.org/index.php?page=3Dimage&id=3D10253
> >>>
> >>> probably the upstream is also affected.
> >>
> >> Hi, Pawe=C5=82
> >>
> >> Are you using a clean 3.6.6 without any modify?
> >=20
> > yes, pure 3.6.6 form git tree with modular config.
> >=20
> >> Looks like some threads has set itself to be UNINTERRUPTIBLE with =
out
> >> any design on switch itself back later(or the time is too long), a=
re you
> >> accidentally using some bad designed module?
> >=20
> > hmm, hard to say. mostly all modules are loaded automatically by ke=
rnel.
>=20
> Could you please provide the whole dmesg in text? your picture lost t=
he
> print info of the hung task.

i've grabbed the console via rs232 but there's no more info (see attach=
ed txt).
the dmesg (filesystem) is not synced during panic (leds on keyboard bli=
nk, sysrq doesn't work).
how can i grab more info?

--nextPart1625853.miIFPt18EW
Content-Disposition: inline; filename="shutdown.txt"
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; name="shutdown.txt"

=0DINIT: Switching to runlevel: 6=0D
=0DINIT: Sending processes the TERM signal=0D
=1B[m=0F=1B[315m=1B[m=0F=1B[32mResource Manager: =1B[m=0F=1B[315mEnteri=
ng runlevel number............................=1B[m=0F=1B[36m[=1B[m=0F=1B=
[32m 6 =1B[m=0F=1B[36m]=1B[m=0F=1B[315m
Stopping automounter service.......................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Setting terminals to default values................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping mdadm service.............................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping Samba SMB/CIFS Server service.............................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping Samba NetBIOS Name Server service.........................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping cronie crond service......................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping NIS client service........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping S.M.A.R.T. Daemon service.................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping block device availability:................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Unmounting NFS filesystems.........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Unmounting NFS filesystems.........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping Name Switch Cache Daemon service..........................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Saving random seed.................................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B=
[m=0F=1B[315m
Stopping NFS daemon service........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping NFS mountd service........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping NFS exportfs service......................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping RPC idmapd service........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping syslog-ng service.........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping D-BUS Message bus service.................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping rpcbind service...........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping OpenSSH service...........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m
Shutting down interface eth0.......................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Shutting down interface eth1.......................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping UPS daemon service........................................Netw=
ork UPS Tools upsd 2.6.4-Unversioned directory
Stopping UPS drivers...............................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping UPSmon service............................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Flushing all chains................................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m
Removing user defined chains.......................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m
Resetting built-in chains to the default ACCEPT policy.............=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m
Flushing all chains................................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m
Removing user defined chains.......................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m
Resetting built-in chains to the default ACCEPT policy.............=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m
Stopping irqbalance service........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Sending all processes the TERM signal..............................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Sending all processes the KILL signal..............................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAN=
D
root         1  5.6  0.0   8468   772 ?        Ss   10:47   0:15 init [=
6]  =20
root         2  0.0  0.0      0     0 ?        S    10:47   0:00 [kthre=
add]
root         3  0.0  0.0      0     0 ?        S    10:47   0:00 [ksoft=
irqd/0]
root         4  0.1  0.0      0     0 ?        S    10:47   0:00 [kwork=
er/0:0]
root         5  0.0  0.0      0     0 ?        S<   10:47   0:00 [kwork=
er/0:0H]
root         6  0.0  0.0      0     0 ?        S    10:47   0:00 [kwork=
er/u:0]
root         7  0.0  0.0      0     0 ?        S<   10:47   0:00 [kwork=
er/u:0H]
root         8  0.0  0.0      0     0 ?        S    10:47   0:00 [migra=
tion/0]
root         9  0.0  0.0      0     0 ?        S    10:47   0:00 [watch=
dog/0]
root        10  0.0  0.0      0     0 ?        S    10:47   0:00 [migra=
tion/1]
root        11  0.0  0.0      0     0 ?        S    10:47   0:00 [kwork=
er/1:0]
root        12  0.0  0.0      0     0 ?        S<   10:47   0:00 [kwork=
er/1:0H]
root        13  0.0  0.0      0     0 ?        S    10:47   0:00 [ksoft=
irqd/1]
root        14  0.0  0.0      0     0 ?        S    10:47   0:00 [watch=
dog/1]
root        15  0.0  0.0      0     0 ?        S    10:47   0:00 [migra=
tion/2]
root        16  0.0  0.0      0     0 ?        S    10:47   0:00 [kwork=
er/2:0]
root        17  0.0  0.0      0     0 ?        S<   10:47   0:00 [kwork=
er/2:0H]
root        18  0.0  0.0      0     0 ?        S    10:47   0:00 [ksoft=
irqd/2]
root        19  0.0  0.0      0     0 ?        S    10:47   0:00 [watch=
dog/2]
root        20  0.0  0.0      0     0 ?        S    10:47   0:00 [migra=
tion/3]
root        21  0.0  0.0      0     0 ?        S    10:47   0:00 [kwork=
er/3:0]
root        22  0.0  0.0      0     0 ?        S<   10:47   0:00 [kwork=
er/3:0H]
root        23  0.0  0.0      0     0 ?        S    10:47   0:00 [ksoft=
irqd/3]
root        24  0.0  0.0      0     0 ?        S    10:47   0:00 [watch=
dog/3]
root        25  0.0  0.0      0     0 ?        S    10:47   0:00 [migra=
tion/4]
root        26  0.0  0.0      0     0 ?        S    10:47   0:00 [kwork=
er/4:0]
root        27  0.0  0.0      0     0 ?        S<   10:47   0:00 [kwork=
er/4:0H]
root        28  0.0  0.0      0     0 ?        S    10:47   0:00 [ksoft=
irqd/4]
root        29  0.0  0.0      0     0 ?        S    10:47   0:00 [watch=
dog/4]
root        30  0.0  0.0      0     0 ?        S    10:47   0:00 [migra=
tion/5]
root        31  0.0  0.0      0     0 ?        S    10:47   0:00 [kwork=
er/5:0]
root        32  0.0  0.0      0     0 ?        S<   10:47   0:00 [kwork=
er/5:0H]
root        33  0.0  0.0      0     0 ?        S    10:47   0:00 [ksoft=
irqd/5]
root        34  0.0  0.0      0     0 ?        S    10:47   0:00 [watch=
dog/5]
root        35  0.0  0.0      0     0 ?        S    10:47   0:00 [migra=
tion/6]
root        36  0.0  0.0      0     0 ?        S    10:47   0:00 [kwork=
er/6:0]
root        37  0.0  0.0      0     0 ?        S<   10:47   0:00 [kwork=
er/6:0H]
root        38  0.0  0.0      0     0 ?        S    10:47   0:00 [ksoft=
irqd/6]
root        39  0.0  0.0      0     0 ?        S    10:47   0:00 [watch=
dog/6]
root        40  0.0  0.0      0     0 ?        S    10:47   0:00 [migra=
tion/7]
root        41  0.0  0.0      0     0 ?        S    10:47   0:00 [kwork=
er/7:0]
root        42  0.0  0.0      0     0 ?        S<   10:47   0:00 [kwork=
er/7:0H]
root        43  0.0  0.0      0     0 ?        S    10:47   0:00 [ksoft=
irqd/7]
root        44  0.0  0.0      0     0 ?        S    10:47   0:00 [watch=
dog/7]
root        45  0.0  0.0      0     0 ?        S    10:47   0:00 [migra=
tion/8]
root        46  0.0  0.0      0     0 ?        S    10:47   0:00 [kwork=
er/8:0]
root        47  0.0  0.0      0     0 ?        S<   10:47   0:00 [kwork=
er/8:0H]
root        48  0.0  0.0      0     0 ?        S    10:47   0:00 [ksoft=
irqd/8]
root        49  0.0  0.0      0     0 ?        S    10:47   0:00 [watch=
dog/8]
root        50  0.0  0.0      0     0 ?        S    10:47   0:00 [migra=
tion/9]
root        51  0.0  0.0      0     0 ?        S    10:47   0:00 [kwork=
er/9:0]
root        52  0.0  0.0      0     0 ?        S<   10:47   0:00 [kwork=
er/9:0H]
root        53  0.0  0.0      0     0 ?        S    10:47   0:00 [ksoft=
irqd/9]
root        54  0.0  0.0      0     0 ?        S    10:47   0:00 [watch=
dog/9]
root        55  0.0  0.0      0     0 ?        S    10:47   0:00 [migra=
tion/10]
root        56  0.0  0.0      0     0 ?        S    10:47   0:00 [kwork=
er/10:0]
root        57  0.0  0.0      0     0 ?        S<   10:47   0:00 [kwork=
er/10:0H]
root        58  0.0  0.0      0     0 ?        S    10:47   0:00 [ksoft=
irqd/10]
root        59  0.0  0.0      0     0 ?        S    10:47   0:00 [watch=
dog/10]
root        60  0.0  0.0      0     0 ?        S    10:47   0:00 [migra=
tion/11]
root        61  0.0  0.0      0     0 ?        S    10:47   0:00 [kwork=
er/11:0]
root        62  0.0  0.0      0     0 ?        S<   10:47   0:00 [kwork=
er/11:0H]
root        63  0.0  0.0      0     0 ?        S    10:47   0:00 [ksoft=
irqd/11]
root        64  0.0  0.0      0     0 ?        S    10:47   0:00 [watch=
dog/11]
root        65  0.0  0.0      0     0 ?        S    10:47   0:00 [migra=
tion/12]
root        66  0.0  0.0      0     0 ?        S    10:47   0:00 [kwork=
er/12:0]
root        67  0.0  0.0      0     0 ?        S<   10:47   0:00 [kwork=
er/12:0H]
root        68  0.0  0.0      0     0 ?        S    10:47   0:00 [ksoft=
irqd/12]
root        69  0.0  0.0      0     0 ?        S    10:47   0:00 [watch=
dog/12]
root        70  0.0  0.0      0     0 ?        S    10:47   0:00 [migra=
tion/13]
root        71  0.0  0.0      0     0 ?        S    10:47   0:00 [kwork=
er/13:0]
root        72  0.0  0.0      0     0 ?        S<   10:47   0:00 [kwork=
er/13:0H]
root        73  0.0  0.0      0     0 ?        S    10:47   0:00 [ksoft=
irqd/13]
root        74  0.1  0.0      0     0 ?        S    10:47   0:00 [watch=
dog/13]
root        75  0.0  0.0      0     0 ?        S    10:47   0:00 [migra=
tion/14]
root        76  0.0  0.0      0     0 ?        S    10:47   0:00 [kwork=
er/14:0]
root        77  0.0  0.0      0     0 ?        S<   10:47   0:00 [kwork=
er/14:0H]
root        78  0.0  0.0      0     0 ?        S    10:47   0:00 [ksoft=
irqd/14]
root        79  0.0  0.0      0     0 ?        S    10:47   0:00 [watch=
dog/14]
root        80  0.0  0.0      0     0 ?        S    10:47   0:00 [migra=
tion/15]
root        81  0.0  0.0      0     0 ?        S    10:47   0:00 [kwork=
er/15:0]
root        82  0.0  0.0      0     0 ?        S<   10:47   0:00 [kwork=
er/15:0H]
root        83  0.0  0.0      0     0 ?        S    10:47   0:00 [ksoft=
irqd/15]
root        84  0.0  0.0      0     0 ?        S    10:47   0:00 [watch=
dog/15]
root        85  0.0  0.0      0     0 ?        S<   10:47   0:00 [cpuse=
t]
root        86  0.0  0.0      0     0 ?        S<   10:47   0:00 [khelp=
er]
root        87  0.0  0.0      0     0 ?        S    10:47   0:00 [kdevt=
mpfs]
root        88  0.0  0.0      0     0 ?        S<   10:47   0:00 [netns=
]
root        89  0.0  0.0      0     0 ?        S    10:47   0:00 [bdi-d=
efault]
root        90  0.0  0.0      0     0 ?        S<   10:47   0:00 [kinte=
grityd]
root        91  0.0  0.0      0     0 ?        S<   10:47   0:00 [kbloc=
kd]
root        92  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/13:1]
root        93  0.0  0.0      0     0 ?        S    10:48   0:00 [irq/4=
0-AMD-Vi]
root        94  0.0  0.0      0     0 ?        S    10:48   0:00 [khung=
taskd]
root        95  0.0  0.0      0     0 ?        S    10:48   0:00 [kswap=
d0]
root        96  0.0  0.0      0     0 ?        S    10:48   0:00 [kswap=
d1]
root        97  0.0  0.0      0     0 ?        S    10:48   0:00 [kswap=
d2]
root        98  0.0  0.0      0     0 ?        S    10:48   0:00 [kswap=
d3]
root        99  0.0  0.0      0     0 ?        SN   10:48   0:00 [ksmd]=

root       100  0.0  0.0      0     0 ?        SN   10:48   0:00 [khuge=
paged]
root       101  0.0  0.0      0     0 ?        S    10:48   0:00 [fsnot=
ify_mark]
root       102  0.0  0.0      0     0 ?        S<   10:48   0:00 [crypt=
o]
root       109  0.0  0.0      0     0 ?        S<   10:48   0:00 [kthro=
tld]
root       110  2.7  0.0      0     0 ?        S    10:48   0:07 [kwork=
er/0:1]
root       111  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/14:1]
root       112  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/15:1]
root       113  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/12:1]
root       114  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/5:1]
root       115  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/1:1]
root       116  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/2:1]
root       117  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/3:1]
root       118  0.0  0.0      0     0 ?        S<   10:48   0:00 [defer=
wq]
root       119  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/u:1]
root       120  0.0  0.0      0     0 ?        S<   10:48   0:00 [charg=
er_manage
root       121  0.0  0.0      0     0 ?        S<   10:48   0:00 [devfr=
eq_wq]
root       122  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/4:1]
root       125  0.5  0.0      0     0 ?        S    10:48   0:01 [kwork=
er/9:1]
root       137  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/6:1]
root       138  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/10:1]
root       141  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/11:1]
root       143  0.0  0.0      0     0 ?        S    10:48   0:00 [khubd=
]
root       145  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/0:2]
root       146  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/7:1]
root       147  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/8:1]
root       153  0.0  0.0      0     0 ?        S<   10:48   0:00 [ata_s=
ff]
root       156  0.1  0.0      0     0 ?        S    10:48   0:00 [scsi_=
eh_0]
root       157  0.0  0.0      0     0 ?        S    10:48   0:00 [scsi_=
eh_1]
root       158  0.0  0.0      0     0 ?        S    10:48   0:00 [scsi_=
eh_2]
root       159  0.1  0.0      0     0 ?        S    10:48   0:00 [scsi_=
eh_3]
root       160  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/u:2]
root       161  0.6  0.0      0     0 ?        S    10:48   0:01 [kwork=
er/u:3]
root       162  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/u:4]
root       163  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/u:5]
root       165  0.0  0.0      0     0 ?        S<   10:48   0:00 [md]
root       169  0.2  0.0      0     0 ?        S<   10:48   0:00 [kwork=
er/0:1H]
root       170  0.0  0.0      0     0 ?        S<   10:48   0:00 [kwork=
er/10:1H]
root       171  0.0  0.0      0     0 ?        S<   10:48   0:00 [kwork=
er/7:1H]
root       172  0.0  0.0      0     0 ?        S<   10:48   0:00 [kwork=
er/4:1H]
root       200  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/1:2]
root       209  0.0  0.0      0     0 ?        S<   10:48   0:00 [kwork=
er/11:1H]
root       210  0.0  0.0      0     0 ?        S<   10:48   0:00 [kwork=
er/13:1H]
root       211  0.0  0.0      0     0 ?        S<   10:48   0:00 [kwork=
er/14:1H]
root       212  0.0  0.0      0     0 ?        S<   10:48   0:00 [kwork=
er/12:1H]
root       213  0.0  0.0      0     0 ?        S<   10:48   0:00 [kwork=
er/15:1H]
root       236  0.0  0.0      0     0 ?        S<   10:48   0:00 [kwork=
er/6:1H]
root       237  0.0  0.0      0     0 ?        S<   10:48   0:00 [kwork=
er/5:1H]
root       284  0.0  0.0      0     0 ?        S    10:48   0:00 [md0_r=
aid1]
root       308  0.0  0.0      0     0 ?        S<   10:48   0:00 [kwork=
er/9:1H]
root       309  0.0  0.0      0     0 ?        S    10:48   0:00 [kjour=
nald]
root       661  0.0  0.0      0     0 ?        S<   10:48   0:00 [kwork=
er/8:1H]
root       664  0.0  0.0      0     0 ?        S<   10:48   0:00 [kwork=
er/1:1H]
root       667  0.0  0.0      0     0 ?        S<   10:48   0:00 [edac-=
poller]
root       672  0.0  0.0      0     0 ?        S<   10:48   0:00 [kvm-i=
rqfd-clea
root       674  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/0:3]
root       675  0.0  0.0      0     0 ?        S<   10:48   0:00 [ttm_s=
wap]
root       677  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/12:2]
root       678  0.0  0.0      0     0 ?        S    10:48   0:00 [flush=
-9:0]
root       690  0.0  0.0      0     0 ?        S    10:48   0:00 [kaudi=
td]
root       816  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/4:2]
root       819  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/6:2]
root       827  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/5:2]
root       828  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/7:2]
root       866  0.7  0.0      0     0 ?        S    10:48   0:01 [jbd2/=
md1-8]
root       867  0.0  0.0      0     0 ?        S<   10:48   0:00 [ext4-=
dio-unwri
root       868  0.0  0.0      0     0 ?        S    10:48   0:00 [jbd2/=
md2-8]
root       869  0.0  0.0      0     0 ?        S<   10:48   0:00 [ext4-=
dio-unwri
root      1291  4.6  0.0      0     0 ?        S    10:48   0:10 [flush=
-9:1]
root      1292  0.0  0.0      0     0 ?        S    10:48   0:00 [flush=
-9:2]
root      1371  0.0  0.0      0     0 ?        SN   10:48   0:00 [kipmi=
0]
root      1394  0.0  0.0      0     0 ?        S<   10:48   0:00 [rpcio=
d]
root      1460  0.0  0.0      0     0 ?        S    10:48   0:00 [lockd=
]
root      1741  0.0  0.0      0     0 ?        S<   10:48   0:00 [kwork=
er/3:1H]
root      1983  0.0  0.0      0     0 ?        S<   10:48   0:00 [nfsio=
d]
2000      1999  0.2  0.0      0     0 ?        D    10:48   0:00 [Xvnc]=

2000      2004  0.0  0.0      0     0 ?        D    10:48   0:00 [vncco=
nfig]
2000      2007  0.0  0.0      0     0 ?        D    10:48   0:00 [sh]
2000      2013  0.0  0.0      0     0 ?        D    10:48   0:00 [xfce4=
-session]
2000      2025  0.0  0.0 320208 11372 ?        D    10:48   0:00 xfwm4=20=

2000      2029  0.0  0.0 500000 13700 ?        D    10:48   0:00 xfce4-=
panel=20
2000      2031  0.0  0.0      0     0 ?        D    10:48   0:00 [Thuna=
r]
2000      2033  0.0  0.0 495880 14220 ?        D    10:48   0:00 xfdesk=
top=20
2000      2041  0.0  0.0 402676  7660 ?        Ds   10:48   0:00 xfsett=
ingsd=20
2000      2061  0.0  0.0      0     0 ?        D    10:48   0:00 [panel=
-6-systra
2000      2063  0.0  0.0      0     0 ?        D    10:48   0:00 [panel=
-2-action
root      2066  0.0  0.0      0     0 ?        S<   10:48   0:00 [kwork=
er/2:1H]
root      2081  0.0  0.0      0     0 ?        S    10:48   0:00 [flush=
-0:29]
root      2194  0.0  0.0      0     0 ?        S    10:48   0:00 [kwork=
er/3:2]
root      2248  0.0  0.0      0     0 ?        S    10:49   0:00 [nfsv4=
.0-svc]
997       2300  0.4  0.0      0     0 ?        D    10:49   0:00 [wish]=

997       3891  0.0  0.0      0     0 ?        Z    10:50   0:00 [slave=
_odra_d_0
root      4156  0.0  0.0      0     0 ?        S    10:51   0:00 [flush=
-0:32]
root      4159  0.1  0.0   4796  1128 ?        Ss   10:51   0:00 /bin/s=
h /etc/rc
root      4524  0.0  0.0      0     0 ?        S    10:52   0:00 [kwork=
er/10:2]
root      4726  0.0  0.0  13084  1056 ?        R    10:52   0:00 ps aux=
=20
+ halt -w
+ is_yes no
+ [ 1 =3D 0 ]
+ return 1
+ run_cmd Turning off swap swapoff -a
+ typeset force_err=3D0 exit_code=3D0 errors user
+ [ 3 -gt 0 ]
+ break
+ typeset message=3DTurning off swap
+ shift
+ show Turning off swap
+ typeset text len
+ is_no no
+ [ 1 =3D 0 ]
+ return 0
+ is_yes yes
+ [ 1 =3D 0 ]
+ return 0
+ nls -n Turning off swap
+ typeset msg_echo nls_domain text message
+ msg_echo=3D\n
+ nls_domain=3D
+ [ -n !=3D n ]
+ msg_echo=3D
+ shift
+ [ Turning off swap !=3D Turning off swap ]
+ message=3DTurning off swap
+ shift
+ [ -z Turning off swap ]
+ is_yes yes
+ [ 1 =3D 0 ]
+ return 0
+ gettext -e --domain=3Drc-scripts Turning off swap
+ TEXTDOMAINDIR=3D/etc/sysconfig/locale
+ message=3DTurning off swap
+ printf Turning off swap
+ echo -en=20
+ text=3DTurning off swap
+ len=3D16
+ [ 16 -lt 67 ]
+ text=3DTurning off swap.
+ [ 17 -lt 67 ]
+ text=3DTurning off swap..
+ [ 18 -lt 67 ]
+ text=3DTurning off swap...
(...)
+ text=3DTurning off swap..............................................=
....
+ [ 66 -lt 67 ]
+ text=3DTurning off swap..............................................=
.....
+ [ 67 -lt 67 ]
+ [ -n  ]
+ echo -n Turning off swap.............................................=
......
Turning off swap...................................................+ bu=
sy
+ echo -n =1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B=
[m=0F=1B[315m
=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m+ cd /
+ export HOME=3D/tmp TMPDIR=3D/tmp
+ is_no no
+ [ 1 =3D 0 ]
+ return 0
+ swapoff -a
+ 2>&1=20
+ errors=3D
+ ok
+ echo =1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[=
m=0F=1B[315m
=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
+ log_success swapoff Turning off swap
+ :
+ [ -n  ]
+ return 0
+ [ -x /etc/rc.d/rc.acct ]
+ [ -x /sbin/quotaoff ]
+ cat /sys/kernel/kexec_loaded
+ 2>/dev/null=20
+ kexec_loaded=3D0
+ sig=3D-15
+ retry=3D3
+ force=3D
+ [ -z  ]
+ UMOUNT_IGNORE=3D/
+ awk -v ig=3D^(/)$ BEGIN { gsub(/[\t ]+/, "|", ig); } \
=09=09=09$3 !~ /^(proc|loopfs|devpts|devtmpfs|shm|iso9660|ramfs|tmpfs|s=
ysfs|securityfs|squashfs)$/ \
=09=09=09&& $1 !~ /^(none|\/dev\/root)$/ \
=09=09=09&& $2 !~ ig {print $2} /proc/mounts
+ remaining=3D/home/atest
/home/users
/proc/fs/nfsd
/var/lib/nfs/rpc_pipefs
/remote/dragon
/remote/nexus
+ [ -n /home/atest
/home/users
/proc/fs/nfsd
/var/lib/nfs/rpc_pipefs
/remote/dragon
/remote/nexus -a 3 -gt 0 ]
+ show Unmounting file systems
+ typeset text len
+ is_no no
+ [ 1 =3D 0 ]
+ return 0
+ is_yes yes
+ [ 1 =3D 0 ]
+ return 0
+ nls -n Unmounting file systems
+ typeset msg_echo nls_domain text message
+ msg_echo=3D\n
+ nls_domain=3D
+ [ -n !=3D n ]
+ msg_echo=3D
+ shift
+ [ Unmounting file systems !=3D Unmounting file systems ]
+ message=3DUnmounting file systems
+ shift
+ [ -z Unmounting file systems ]
+ is_yes yes
+ [ 1 =3D 0 ]
+ return 0
+ gettext -e --domain=3Drc-scripts Unmounting file systems
+ TEXTDOMAINDIR=3D/etc/sysconfig/locale
+ message=3DUnmounting file systems
+ printf Unmounting file systems
+ echo -en=20
+ text=3DUnmounting file systems
+ len=3D23
+ [ 23 -lt 67 ]
+ text=3DUnmounting file systems.
+ [ 24 -lt 67 ]
+ text=3DUnmounting file systems..
(...)
+ text=3DUnmounting file systems.......................................=
.....
+ [ 67 -lt 67 ]
+ [ -n  ]
+ echo -n Unmounting file systems......................................=
......
Unmounting file systems............................................+ bu=
sy
+ echo -n =1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B=
[m=0F=1B[315m
=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m+ umount -a -t noproc
+ 2>&1=20
+ ERRORS=3Dumount: /home/atest: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount: /dev: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
+ rc=3D32
+ is_yes yes
+ [ 1 =3D 0 ]
+ return 0
+ TPUT=3D
+ rc_gettext_init
+ [ -z yes ]
+ [ -z  ]
+ [ -d /usr/share/terminfo ]
+ [ -x /usr/bin/tput -o -x /bin/tput ]
+ TPUT=3Dyes
+ tput longname
+ >/dev/null=20
+ 2>&1=20
+ [ 32 =3D 0 ]
+ fail
+ echo =1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[31m FAIL =1B[m=0F=1B[36m]=1B[=
m=0F=1B[315m
=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[31m FAIL =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
+ return 1
+ [ -n umount: /home/atest: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount: /dev: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1)) ]
+ echo umount: /home/atest: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount: /dev: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount: /home/atest: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount: /dev: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
+ sleep 2
+ awk -v ig=3D^(/)$ BEGIN { gsub(/[\t ]+/, "|", ig); } \
=09=09=09=09$3 !~ /^(proc|loopfs|devpts|devtmpfs|shm|iso9660|ramfs|tmpf=
s|sysfs|securityfs|squashfs)$/ \
=09=09=09=09&& $1 !~ /^(none|\/dev\/root)$/ \
=09=09=09=09&& $2 !~ ig {print $2} /proc/mounts
+ remaining=3D/home/atest
+ [ -z /home/atest ]
+ fuser -k -m -15 /home/atest
+ >/dev/null=20
Cannot stat file /proc/2025/fd/1: Connection timed out
Cannot stat file /proc/2025/fd/2: Connection timed out
Cannot stat file /proc/2029/fd/1: Connection timed out
Cannot stat file /proc/2029/fd/2: Connection timed out
Cannot stat file /proc/2033/fd/1: Connection timed out
Cannot stat file /proc/2033/fd/2: Connection timed out
Cannot stat file /proc/2041/fd/1: Connection timed out
Cannot stat file /proc/2041/fd/2: Connection timed out
+ sleep 5
+ retry=3D2
+ sig=3D-9
+ force=3D-f
+ [ -n /home/atest -a 2 -gt 0 ]
+ show Unmounting file systems
+ typeset text len
+ is_no no
+ [ 1 =3D 0 ]
+ return 0
+ is_yes yes
+ [ 1 =3D 0 ]
+ return 0
+ nls -n Unmounting file systems
+ typeset msg_echo nls_domain text message
+ msg_echo=3D\n
+ nls_domain=3D
+ [ -n !=3D n ]
+ msg_echo=3D
+ shift
+ [ Unmounting file systems !=3D Unmounting file systems ]
+ message=3DUnmounting file systems
+ shift
+ [ -z Unmounting file systems ]
+ is_yes yes
+ [ 1 =3D 0 ]
+ return 0
+ gettext -e --domain=3Drc-scripts Unmounting file systems
+ TEXTDOMAINDIR=3D/etc/sysconfig/locale
+ message=3DUnmounting file systems
+ printf Unmounting file systems
+ echo -en=20
+ text=3DUnmounting file systems
+ len=3D23
+ [ 23 -lt 67 ]
+ text=3DUnmounting file systems.
+ [ 24 -lt 67 ]
+ text=3DUnmounting file systems..
(...)
+ text=3DUnmounting file systems.......................................=
.....
+ [ 67 -lt 67 ]
+ [ -n  ]
+ echo -n Unmounting file systems......................................=
......
Unmounting file systems............................................+ bu=
sy
+ echo -n =1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B=
[m=0F=1B[315m
=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m+ umount -a -f -t noproc
+ 2>&1=20
+ ERRORS=3Dumount: /home/atest: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount: /dev: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
+ rc=3D32
+ is_yes yes
+ [ 1 =3D 0 ]
+ return 0
+ TPUT=3D
+ rc_gettext_init
+ [ -z yes ]
+ [ -z  ]
+ [ -d /usr/share/terminfo ]
+ [ -x /usr/bin/tput -o -x /bin/tput ]
+ TPUT=3Dyes
+ tput longname
+ >/dev/null=20
+ 2>&1=20
+ [ 32 =3D 0 ]
+ fail
+ echo =1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[31m FAIL =1B[m=0F=1B[36m]=1B[=
m=0F=1B[315m
=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[31m FAIL =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
+ return 1
+ [ -n umount: /home/atest: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount: /dev: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1)) ]
+ echo umount: /home/atest: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount: /dev: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount: /home/atest: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount: /dev: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
+ sleep 2
+ awk -v ig=3D^(/)$ BEGIN { gsub(/[\t ]+/, "|", ig); } \
=09=09=09=09$3 !~ /^(proc|loopfs|devpts|devtmpfs|shm|iso9660|ramfs|tmpf=
s|sysfs|securityfs|squashfs)$/ \
=09=09=09=09&& $1 !~ /^(none|\/dev\/root)$/ \
=09=09=09=09&& $2 !~ ig {print $2} /proc/mounts
+ remaining=3D/home/atest
+ [ -z /home/atest ]
+ fuser -k -m -9 /home/atest
+ >/dev/null=20
Cannot stat file /proc/2025/fd/1: Connection timed out
Cannot stat file /proc/2025/fd/2: Connection timed out
Cannot stat file /proc/2029/fd/1: Connection timed out
Cannot stat file /proc/2029/fd/2: Connection timed out
Cannot stat file /proc/2033/fd/1: Connection timed out
Cannot stat file /proc/2033/fd/2: Connection timed out
Cannot stat file /proc/2041/fd/1: Connection timed out
Cannot stat file /proc/2041/fd/2: Connection timed out
+ sleep 5
+ retry=3D1
+ sig=3D-9
+ force=3D-f
+ [ -n /home/atest -a 1 -gt 0 ]
+ show Unmounting file systems
+ typeset text len
+ is_no no
+ [ 1 =3D 0 ]
+ return 0
+ is_yes yes
+ [ 1 =3D 0 ]
+ return 0
+ nls -n Unmounting file systems
+ typeset msg_echo nls_domain text message
+ msg_echo=3D\n
+ nls_domain=3D
+ [ -n !=3D n ]
+ msg_echo=3D
+ shift
+ [ Unmounting file systems !=3D Unmounting file systems ]
+ message=3DUnmounting file systems
+ shift
+ [ -z Unmounting file systems ]
+ is_yes yes
+ [ 1 =3D 0 ]
+ return 0
+ gettext -e --domain=3Drc-scripts Unmounting file systems
+ TEXTDOMAINDIR=3D/etc/sysconfig/locale
+ message=3DUnmounting file systems
+ printf Unmounting file systems
+ echo -en=20
+ text=3DUnmounting file systems
+ len=3D23
+ [ 23 -lt 67 ]
+ text=3DUnmounting file systems.
+ [ 24 -lt 67 ]
+ text=3DUnmounting file systems..
(...)
+ [ 67 -lt 67 ]
+ [ -n  ]
+ echo -n Unmounting file systems......................................=
......
Unmounting file systems............................................+ bu=
sy
+ echo -n =1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B=
[m=0F=1B[315m
=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m+ umount -a -f -t noproc
+ 2>&1=20
+ ERRORS=3Dumount: /home/atest: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount: /dev: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
+ rc=3D32
+ is_yes yes
+ [ 1 =3D 0 ]
+ return 0
+ TPUT=3D
+ rc_gettext_init
+ [ -z yes ]
+ [ -z  ]
+ [ -d /usr/share/terminfo ]
+ [ -x /usr/bin/tput -o -x /bin/tput ]
+ TPUT=3Dyes
+ tput longname
+ >/dev/null=20
+ 2>&1=20
+ [ 32 =3D 0 ]
+ fail
+ echo =1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[31m FAIL =1B[m=0F=1B[36m]=1B[=
m=0F=1B[315m
=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[31m FAIL =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
+ return 1
+ [ -n umount: /home/atest: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount: /dev: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1)) ]
+ echo umount: /home/atest: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount: /dev: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount: /home/atest: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount: /dev: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
+ sleep 2
+ awk -v ig=3D^(/)$ BEGIN { gsub(/[\t ]+/, "|", ig); } \
=09=09=09=09$3 !~ /^(proc|loopfs|devpts|devtmpfs|shm|iso9660|ramfs|tmpf=
s|sysfs|securityfs|squashfs)$/ \
=09=09=09=09&& $1 !~ /^(none|\/dev\/root)$/ \
=09=09=09=09&& $2 !~ ig {print $2} /proc/mounts
+ remaining=3D/home/atest
+ [ -z /home/atest ]
+ fuser -k -m -9 /home/atest
+ >/dev/null=20
Cannot stat file /proc/2025/fd/1: Connection timed out
Cannot stat file /proc/2025/fd/2: Connection timed out
Cannot stat file /proc/2029/fd/1: Connection timed out
Cannot stat file /proc/2029/fd/2: Connection timed out
Cannot stat file /proc/2033/fd/1: Connection timed out
Cannot stat file /proc/2033/fd/2: Connection timed out
+ sleep 5
+ retry=3D0
+ sig=3D-9
+ force=3D-f
+ [ -n /home/atest -a 0 -gt 0 ]
+ run_cmd Remounting root filesystem in ro mode mount -n -o remount,ro =
/
+ typeset force_err=3D0 exit_code=3D0 errors user
+ [ 6 -gt 0 ]
+ break
+ typeset message=3DRemounting root filesystem in ro mode
+ shift
+ show Remounting root filesystem in ro mode
+ typeset text len
+ is_no no
+ [ 1 =3D 0 ]
+ return 0
+ is_yes yes
+ [ 1 =3D 0 ]
+ return 0
+ nls -n Remounting root filesystem in ro mode
+ typeset msg_echo nls_domain text message
+ msg_echo=3D\n
+ nls_domain=3D
+ [ -n !=3D n ]
+ msg_echo=3D
+ shift
+ [ Remounting root filesystem in ro mode !=3D Remounting root filesyst=
em in ro mode ]
+ message=3DRemounting root filesystem in ro mode
+ shift
+ [ -z Remounting root filesystem in ro mode ]
+ is_yes yes
+ [ 1 =3D 0 ]
+ return 0
+ gettext -e --domain=3Drc-scripts Remounting root filesystem in ro mod=
e
+ TEXTDOMAINDIR=3D/etc/sysconfig/locale
+ message=3DRemounting root filesystem in ro mode
+ printf Remounting root filesystem in ro mode
+ echo -en=20
+ text=3DRemounting root filesystem in ro mode
+ len=3D37
+ [ 37 -lt 67 ]
+ text=3DRemounting root filesystem in ro mode.
+ [ 38 -lt 67 ]
+ text=3DRemounting root filesystem in ro mode..
(...)
+ text=3DRemounting root filesystem in ro mode.........................=
.....
+ [ 67 -lt 67 ]
+ [ -n  ]
+ echo -n Remounting root filesystem in ro mode........................=
......
Remounting root filesystem in ro mode..............................+ bu=
sy
+ echo -n =1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B=
[m=0F=1B[315m
=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m+ cd /
+ export HOME=3D/tmp TMPDIR=3D/tmp
+ is_no no
+ [ 1 =3D 0 ]
+ return 0
+ mount -n -o remount,ro /
+ 2>&1=20
+ errors=3Dmount: / is busy
+ fail
+ echo =1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[31m FAIL =1B[m=0F=1B[36m]=1B[=
m=0F=1B[315m
=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[31m FAIL =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
+ return 1
+ log_failed mount Remounting root filesystem in ro mode
+ :
+ exit_code=3D1
+ [ -n mount: / is busy ]
+ [ 1 -eq 1 -o 0 -eq 1 ]
+ echo mount: / is busy
mount: / is busy
+ return 1
+ [ -x /sbin/vgchange ]
+ /sbin/vgchange --version
+ 2>/dev/null=20
+ awk /LVM version:/{if ($3 >=3D 2) print "2"}
+ lvmversion=3D2
+ [ 2 =3D 2 ]
+ lvmsysinit=3D--sysinit
+ /sbin/vgchange -a n --sysinit
+ >/dev/null=20
+ 2>&1=20
+ goraidtab=3D1
+ [ -x /sbin/mdadm -a -f /etc/mdadm.conf ]
+ grep -qE ^([[:blank:]]|)ARRAY[[:blank:]] /etc/mdadm.conf
+ 2>/dev/null=20
+ /sbin/mdadm --stop --scan
+ >/dev/null=20
+ 2>&1=20
+ rc=3D1
+ [ 1 -eq 0 ]
+ [ -x /sbin/raidstop -a -f /etc/raidtab -a 1 -eq 1 ]
+ show Remounting remaining filesystems ro mode
+ typeset text len
+ is_no no
+ [ 1 =3D 0 ]
+ return 0
+ is_yes yes
+ [ 1 =3D 0 ]
+ return 0
+ nls -n Remounting remaining filesystems ro mode
+ typeset msg_echo nls_domain text message
+ msg_echo=3D\n
+ nls_domain=3D
+ [ -n !=3D n ]
+ msg_echo=3D
+ shift
+ [ Remounting remaining filesystems ro mode !=3D Remounting remaining =
filesystems ro mode ]
+ message=3DRemounting remaining filesystems ro mode
+ shift
+ [ -z Remounting remaining filesystems ro mode ]
+ is_yes yes
+ [ 1 =3D 0 ]
+ return 0
+ gettext -e --domain=3Drc-scripts Remounting remaining filesystems ro =
mode
+ TEXTDOMAINDIR=3D/etc/sysconfig/locale
+ message=3DRemounting remaining filesystems ro mode
+ printf Remounting remaining filesystems ro mode
+ echo -en=20
+ text=3DRemounting remaining filesystems ro mode
+ len=3D40
+ [ 40 -lt 67 ]
+ text=3DRemounting remaining filesystems ro mode.
(...)
+ text=3DRemounting remaining filesystems ro mode......................=
.....
+ [ 67 -lt 67 ]
+ [ -n  ]
+ echo -n Remounting remaining filesystems ro mode.....................=
......
Remounting remaining filesystems ro mode...........................+ bu=
sy
+ echo -n =1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B=
[m=0F=1B[315m
=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m+ mount
+ awk /ext2|ext3|reiserfs|xfs|jfs/ { print $3 }
+ read line
+ mount -n -o ro,remount /
mount: / is busy
+ read line
+ fail
+ echo =1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[31m FAIL =1B[m=0F=1B[36m]=1B[=
m=0F=1B[315m
=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[31m FAIL =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
+ return 1
+ _rebootwhat=3Dsystem
+ [ -f /etc/crypttab ]
+ is_empty_file /etc/crypttab
+ [ -s /etc/crypttab ]
+ grep -vqE ^(#|[[:blank:]]*$) /etc/crypttab
+ return 0
+ [ 6 =3D 0 ]
+ show Please stand by while rebooting the system
+ typeset text len
+ is_no no
+ [ 1 =3D 0 ]
+ return 0
+ is_yes yes
+ [ 1 =3D 0 ]
+ return 0
+ nls -n Please stand by while rebooting the system
+ typeset msg_echo nls_domain text message
+ msg_echo=3D\n
+ nls_domain=3D
+ [ -n !=3D n ]
+ msg_echo=3D
+ shift
+ [ Please stand by while rebooting the system !=3D Please stand by whi=
le rebooting the system ]
+ message=3DPlease stand by while rebooting the system
+ shift
+ [ -z Please stand by while rebooting the system ]
+ is_yes yes
+ [ 1 =3D 0 ]
+ return 0
+ gettext -e --domain=3Drc-scripts Please stand by while rebooting the =
system
+ TEXTDOMAINDIR=3D/etc/sysconfig/locale
+ message=3DPlease stand by while rebooting the system
+ printf Please stand by while rebooting the system
+ echo -en=20
+ text=3DPlease stand by while rebooting the system
+ len=3D42
+ [ 42 -lt 67 ]
+ text=3DPlease stand by while rebooting the system.
(...)
+ text=3DPlease stand by while rebooting the system....................=
.....
+ [ 67 -lt 67 ]
+ [ -n  ]
+ echo -n Please stand by while rebooting the system...................=
......
Please stand by while rebooting the system.........................+ ok=

+ echo =1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[=
m=0F=1B[315m
=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
+ [ -f /fastboot ]
+ emit stopped JOB=3Dshutdown
+ use_upstart
+ is_yes no
+ [ 1 =3D 0 ]
+ return 1
+ is_no no
+ [ 1 =3D 0 ]
+ return 0
+ return 1
+ return 0
+ emit stopping JOB=3Dshutdown
+ use_upstart
+ is_yes no
+ [ 1 =3D 0 ]
+ return 1
+ is_no no
+ [ 1 =3D 0 ]
+ return 0
+ return 1
+ return 0
+ [ -x /sbin/kexec ]
+ [ 3 !=3D unknown ]
+ eval reboot -d -f
+ reboot -d -f
[  493.548872] Kernel panic - not syncing: hung_task: blocked tasks
[  493.620619] Pid: 94, comm: khungtaskd Tainted: G        W    3.6.6 #=
15
[  493.698572] Call Trace:
[  493.727745]  [<ffffffff8149d2a8>] panic+0xbc/0x1cb
[  493.784938]  [<ffffffff810c6eb5>] watchdog+0x245/0x250
[  493.846286]  [<ffffffff810c6c70>] ? hung_task_panic+0x20/0x20
[  493.914898]  [<ffffffff810727ce>] kthread+0x8e/0xa0
[  493.973132]  [<ffffffff814afa04>] kernel_thread_helper+0x4/0x10
[  494.043821]  [<ffffffff81072740>] ? kthread_freezable_should_stop+0x=
70/0x70
[  494.126966]  [<ffffffff814afa00>] ? gs_change+0x13/0x13
[  494.189390] panic occurred, switching back to text console
[  494.254971] ------------[ cut here ]------------
[  494.310074] WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_re=
schedule+0x53/0x60()
[  494.406710] Hardware name: H8DGU
[  494.445221] Modules linked in: nfsv4 fuse nfsv3 nfs fscache nfsd loc=
kd nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_=
sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip=
table_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filt=
er ip6_tables x_tables ext4 jbd2 crc16 raid0 dm_mod autofs4 dummy ide_c=
d_mod cdrom ata_generic pata_acpi sp5100_tco pata_atiixp ide_pci_generi=
c mgag200 ttm drm_kms_helper drm igb powernow_k8 freq_table mperf joyde=
v kvm_amd i2c_algo_bit sysimgblt sysfillrect syscopyarea dca ptp hid_ge=
neric kvm pps_core k10temp microcode i2c_piix4 evdev pcspkr hwmon amd64=
_edac_mod edac_core atiixp ide_core edac_mce_amd i2c_core processor but=
ton ext3 jbd mbcache sd_mod crc_t10dif raid1 md_mod ahci libahci libata=
 scsi_mod usbhid hid ohci_hcd ehci_hcd usbcore usb_common
[  495.326812] Pid: 94, comm: khungtaskd Tainted: G        W    3.6.6 #=
15
[  495.404768] Call Trace:
[  495.433938]  <IRQ>  [<ffffffff810500da>] warn_slowpath_common+0x7a/0=
xb0
[  495.513036]  [<ffffffff81050125>] warn_slowpath_null+0x15/0x20
[  495.582688]  [<ffffffff81034d73>] native_smp_send_reschedule+0x53/0x=
60
[  495.660644]  [<ffffffff81089fcc>] trigger_load_balance+0x17c/0x220
[  495.734446]  [<ffffffff81081ae4>] scheduler_tick+0x104/0x140
[  495.802022]  [<ffffffff810611d7>] update_process_times+0x67/0x80
[  495.873749]  [<ffffffff8109e579>] tick_sched_timer+0x69/0xe0
[  495.941324]  [<ffffffff810769ce>] __run_hrtimer+0x6e/0x1c0
[  496.006822]  [<ffffffff8109e510>] ? tick_nohz_handler+0x100/0x100
[  496.079589]  [<ffffffff81058a15>] ? __do_softirq+0x115/0x1f0
[  496.147163]  [<ffffffff810772af>] hrtimer_interrupt+0xef/0x220
[  496.216814]  [<ffffffff81035b34>] smp_apic_timer_interrupt+0x64/0xa0=

[  496.292694]  [<ffffffff814af40a>] apic_timer_interrupt+0x6a/0x70
[  496.364420]  <EOI>  [<ffffffff8149d373>] ? panic+0x187/0x1cb
[  496.432100]  [<ffffffff810c6eb5>] watchdog+0x245/0x250
[  496.493445]  [<ffffffff810c6c70>] ? hung_task_panic+0x20/0x20
[  496.562059]  [<ffffffff810727ce>] kthread+0x8e/0xa0
[  496.620293]  [<ffffffff814afa04>] kernel_thread_helper+0x4/0x10
[  496.690981]  [<ffffffff81072740>] ? kthread_freezable_should_stop+0x=
70/0x70
[  496.774126]  [<ffffffff814afa00>] ? gs_change+0x13/0x13
[  496.836511] ---[ end trace f42d1c6fc3b40f64 ]---

--nextPart1625853.miIFPt18EW--

