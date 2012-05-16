Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab2EPOdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:33:39 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45934 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2EPOdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:33:38 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: a3at.mail@gmail.com
Date: Wed, 16 May 2012 18:33:35 +0400
X-Google-Sender-Auth: VzSb_ypyi6REFqxUKh70_BLxBBQ
Message-ID: <CAAW1UO_8N-10gLzKp4gV-P3JGOsk-_QnZiedWjhw3rWe33fKjQ@mail.gmail.com>
Subject: wrong count of CPU usage
From: Azat Khuzhin <dohardgopro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016e6de00d34dae2004c028343f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6de00d34dae2004c028343f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all

I have machine that have uptime 212 days, kernel version:=C2=A0Linux
2.6.35.14-97.fc14.x86_64 #1 SMP Sat Sep 17 00:15:37 UTC 2011 x86_64
x86_64 x86_64 GNU/Linux
Before top (1) utility shows some activity per process,=C2=A0as it should
be (sort by %CPU column)

But from some time, no activity in top (1) per process at all
=C2=A0 PID USER =C2=A0 =C2=A0 =C2=A0PR =C2=A0NI =C2=A0VIRT =C2=A0RES =C2=A0=
SHR S %CPU %MEM =C2=A0 =C2=A0TIME+ =C2=A0COMMAND
=C2=A0 =C2=A0 1 root =C2=A0 =C2=A0 =C2=A020 =C2=A0 0 19420 1548 1240 S =C2=
=A00.0 =C2=A00.0 =C2=A017:48.09 init
=C2=A0 =C2=A0 2 root =C2=A0 =C2=A0 =C2=A020 =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0=
 =C2=A00 =C2=A0 =C2=A00 S =C2=A00.0 =C2=A00.0 =C2=A0 0:09.72 kthreadd
=C2=A0 =C2=A0 3 root =C2=A0 =C2=A0 =C2=A020 =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0=
 =C2=A00 =C2=A0 =C2=A00 S =C2=A00.0 =C2=A00.0 =C2=A020:34.76 ksoftirqd/0

But load avg > 10
top (1) shows some activity on cores (I mean not processes, that
created by kernel)
top - 09:58:26 up 212 days, =C2=A07:06, =C2=A08 users, =C2=A0load average: =
13.27, 12.20, 11.37
Tasks: 815 total, =C2=A0 9 running, 803 sleeping, =C2=A0 2 stopped, =C2=A0 =
1 zombie
Cpu0 =C2=A0: 47.5%us, =C2=A08.0%sy, =C2=A00.3%ni, 26.4%id, 16.9%wa, =C2=A00=
.0%hi, =C2=A00.9%si, =C2=A00.0%st
Cpu1 =C2=A0: 39.7%us, =C2=A05.2%sy, =C2=A00.0%ni, 48.0%id, =C2=A06.8%wa, =
=C2=A00.0%hi, =C2=A00.3%si, =C2=A00.0%st
Cpu2 =C2=A0: 29.8%us, =C2=A03.1%sy, =C2=A00.0%ni, 59.7%id, =C2=A07.4%wa, =
=C2=A00.0%hi, =C2=A00.0%si, =C2=A00.0%st
Cpu3 =C2=A0: 15.9%us, =C2=A02.8%sy, =C2=A00.0%ni, 77.3%id, =C2=A03.7%wa, =
=C2=A00.0%hi, =C2=A00.3%si, =C2=A00.0%st
Cpu4 =C2=A0: 39.3%us, =C2=A05.2%sy, =C2=A00.0%ni, 37.4%id, 17.8%wa, =C2=A00=
.0%hi, =C2=A00.3%si, =C2=A00.0%st
Cpu5 =C2=A0: 29.6%us, =C2=A04.0%sy, =C2=A00.0%ni, 62.3%id, =C2=A03.7%wa, =
=C2=A00.0%hi, =C2=A00.3%si, =C2=A00.0%st
Cpu6 =C2=A0: 20.4%us, =C2=A05.0%sy, =C2=A00.0%ni, 74.3%id, =C2=A00.0%wa, =
=C2=A00.0%hi, =C2=A00.3%si, =C2=A00.0%st
Cpu7 =C2=A0: 17.3%us, =C2=A02.8%sy, =C2=A00.0%ni, 76.8%id, =C2=A03.1%wa, =
=C2=A00.0%hi, =C2=A00.0%si, =C2=A00.0%st
Cpu8 =C2=A0: 32.8%us, =C2=A06.5%sy, =C2=A00.0%ni, 31.6%id, 29.1%wa, =C2=A00=
.0%hi, =C2=A00.0%si, =C2=A00.0%st
Cpu9 =C2=A0: 27.6%us, =C2=A03.1%sy, =C2=A00.0%ni, 69.3%id, =C2=A00.0%wa, =
=C2=A00.0%hi, =C2=A00.0%si, =C2=A00.0%st
Cpu10 : =C2=A06.8%us, =C2=A02.5%sy, =C2=A00.0%ni, 87.9%id, =C2=A02.8%wa, =
=C2=A00.0%hi, =C2=A00.0%si, =C2=A00.0%st
Cpu11 : =C2=A08.7%us, =C2=A01.9%sy, =C2=A00.0%ni, 89.4%id, =C2=A00.0%wa, =
=C2=A00.0%hi, =C2=A00.0%si, =C2=A00.0%st
Cpu12 : 27.3%us, =C2=A02.8%sy, =C2=A00.0%ni, 52.8%id, 17.1%wa, =C2=A00.0%hi=
, =C2=A00.0%si, =C2=A00.0%st
Cpu13 : 18.2%us, =C2=A03.7%sy, =C2=A00.0%ni, 77.5%id, =C2=A00.6%wa, =C2=A00=
.0%hi, =C2=A00.0%si, =C2=A00.0%st
Cpu14 : 21.4%us, =C2=A03.8%sy, =C2=A00.0%ni, 74.8%id, =C2=A00.0%wa, =C2=A00=
.0%hi, =C2=A00.0%si, =C2=A00.0%st
Cpu15 : 10.0%us, =C2=A01.9%sy, =C2=A00.0%ni, 87.9%id, =C2=A00.3%wa, =C2=A00=
.0%hi, =C2=A00.0%si, =C2=A00.0%st

So seems like after some time kernel not updating /proc/PID/stat properly

I wrote shell script (attach), that count CPU usage, and it also shows 0
This script base on 14, 15 columns from /proc/PID/stat (as man proc
says, that it utime and stime clocks, and /proc/stat summary), but for
newly created processes

Summarize
/proc/PID/stat seems not change counters utime, stime
/proc/stat updated

--
Azat Khuzhin

--0016e6de00d34dae2004c028343f
Content-Type: application/octet-stream; name=cpu_usage
Content-Disposition: attachment; filename=cpu_usage
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h2ahqnti0

IyEvYmluL2Jhc2gKClBJRD0kMQoKaWYgWyAieCRQSUQiID0gIngiIF0gOyB0aGVuCglleGl0IDEK
ZmkKCiMgdXRpbWUKVVNFUl9TVEFSVD1gYXdrICd7cHJpbnQgJDE0fScgL3Byb2MvJFBJRC9zdGF0
YApVU0VSX0FMTF9TVEFSVD1gaGVhZCAtbjEgL3Byb2Mvc3RhdCB8IGF3ayAnQkVHSU4ge3N1bSA9
IDB9IHsgZm9yIChpID0gMTsgaSA8PSBORjsgKytpKSB7IHN1bSArPSAkaSB9IH0gRU5EIHtwcmlu
dCBzdW19J2AKc2xlZXAgMQpVU0VSX0VORD1gYXdrICd7cHJpbnQgJDE0fScgL3Byb2MvJFBJRC9z
dGF0YApVU0VSX0FMTF9FTkQ9YGhlYWQgLW4xIC9wcm9jL3N0YXQgfCBhd2sgJ0JFR0lOIHtzdW0g
PSAwfSB7IGZvciAoaSA9IDE7IGkgPD0gTkY7ICsraSkgeyBzdW0gKz0gJGkgfSB9IEVORCB7cHJp
bnQgc3VtfSdgClVTRVI9YGVjaG8gInNhY2xlPTU7IDEwMCAqICgkVVNFUl9FTkQgLSAkVVNFUl9T
VEFSVCkgLyAoJFVTRVJfQUxMX0VORCAtICRVU0VSX0FMTF9TVEFSVCkiIHwgYmNgCmVjaG8gIltw
cm9jZXNzXSBqaWZmaWVzIGZvciAxIHNlYzogJCgoICRVU0VSX0VORCAtICRVU0VSX1NUQVJUICkp
IgplY2hvICJbICAgIGFsbF0gamlmZmllcyBmb3IgMSBzZWM6ICQoKCAkVVNFUl9BTExfRU5EIC0g
JFVTRVJfQUxMX1NUQVJUICkpIgplY2hvICJbICAgY3B1JV0gJFVTRVIgJSIKCiMgc3RpbWUKU1lT
X1NUQVJUPWBhd2sgJ3twcmludCAkMTV9JyAvcHJvYy8kUElEL3N0YXRgClNZU19BTExfU1RBUlQ9
YGhlYWQgLW4xIC9wcm9jL3N0YXQgfCBhd2sgJ0JFR0lOIHtzdW0gPSAwfSB7IGZvciAoaSA9IDE7
IGkgPD0gTkY7ICsraSkgeyBzdW0gKz0gJGkgfSB9IEVORCB7cHJpbnQgc3VtfSdgCnNsZWVwIDEK
U1lTX0VORD1gYXdrICd7cHJpbnQgJDE1fScgL3Byb2MvJFBJRC9zdGF0YApTWVNfQUxMX0VORD1g
aGVhZCAtbjEgL3Byb2Mvc3RhdCB8IGF3ayAnQkVHSU4ge3N1bSA9IDB9IHsgZm9yIChpID0gMTsg
aSA8PSBORjsgKytpKSB7IHN1bSArPSAkaSB9IH0gRU5EIHtwcmludCBzdW19J2AKU1lTPWBlY2hv
ICJzY2FsZT01OyAxMDAgKiAoJFNZU19FTkQgLSAkU1lTX1NUQVJUKSAvICgkU1lTX0FMTF9FTkQg
LSAkU1lTX0FMTF9TVEFSVCkiIHwgYmNgCmVjaG8gIltwcm9jZXNzXSBqaWZmaWVzIGZvciAxIHNl
YzogJCgoICRTWVNfRU5EIC0gJFNZU19TVEFSVCApKSIKZWNobyAiWyAgICBhbGxdIGppZmZpZXMg
Zm9yIDEgc2VjOiAkKCggJFNZU19BTExfRU5EIC0gJFNZU19BTExfU1RBUlQgKSkiCmVjaG8gIlsg
ICBjcHUlXSAkU1lTICUiCgo=
--0016e6de00d34dae2004c028343f--
