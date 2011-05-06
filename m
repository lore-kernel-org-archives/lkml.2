Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab1EFAhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:37:47 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:28120 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754197Ab1EFAho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:37:44 -0400
From: "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>
To: "'Marc Kleine-Budde'" <mkl@pengutronix.de>
Cc: "'Wolfgang Grandegger'" <wg@grandegger.com>,
        <socketcan-core@lists.berlios.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <toshiharu-linux@dsn.okisemi.com>
References: <02D6556ECE7A41859777EB7300D12394@hacdom.okisemi.com> <4DB81F2E.4050802@pengutronix.de>
Subject: RE: Question for canutils
Date: Fri, 6 May 2011 09:37:40 +0900
Message-ID: <A42D429EA0C74B64BB1BFE96BBFA9815@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Thread-Index: AcwE4hxAM4FylSFMTa2Yyp0meT65tgGop4Qg
In-Reply-To: <4DB81F2E.4050802@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On Wednesday, April 27, 2011 10:51 PM, Marc Kleine-Budde wrote:
> Into which location?
> 
> Please send me the output of:
> 
> ls -l /usr/local/lib
> ls -l /usr/local/lib/pkgconfig

[morinaga@localhost ~]$ 
[morinaga@localhost ~]$ ls -l /usr/local/lib
合計 1412
-rw-r--r--. 1 root root 103226 2011-01-13 16:56 libhistory.a
lrwxrwxrwx. 1 root root     15 2011-01-13 16:56 libhistory.so -> libhistory.so.6
lrwxrwxrwx. 1 root root     17 2011-01-13 16:56 libhistory.so.6 -> libhistory.so.6.0
-r-xr-xr-x. 1 root root  80204 2011-01-13 16:56 libhistory.so.6.0
-rw-r--r--. 1 root root 686760 2011-01-13 16:56 libreadline.a
lrwxrwxrwx. 1 root root     16 2011-01-13 16:56 libreadline.so -> libreadline.so.6
lrwxrwxrwx. 1 root root     18 2011-01-13 16:56 libreadline.so.6 -> libreadline.so.6.0
-r-xr-xr-x. 1 root root 498839 2011-01-13 16:56 libreadline.so.6.0
-rw-r--r--. 1 root root  28718 2011-04-27 15:40 libsocketcan.a
-rwxr-xr-x. 1 root root    843 2011-04-27 15:40 libsocketcan.la
lrwxrwxrwx. 1 root root     21 2011-04-27 15:40 libsocketcan.so -> libsocketcan.so.2.2.0
lrwxrwxrwx. 1 root root     21 2011-04-27 15:40 libsocketcan.so.2 -> libsocketcan.so.2.2.0
-rwxr-xr-x. 1 root root  27835 2011-04-27 15:40 libsocketcan.so.2.2.0
drwxr-xr-x. 2 root root   4096 2011-04-27 15:53 pkgconfig
[morinaga@localhost ~]$ ls -l /usr/local/lib/pkgconfig/
合計 8
-rw-r--r--. 1 root root 198 2011-04-27 15:53 canutils.pc
-rw-r--r--. 1 root root 300 2011-04-27 15:40 libsocketcan.pc
[morinaga@localhost ~]$ 


> First build the canutils, then configure the bitrate, e.g. 250 kbit/s:
>     $ canconfig can0 bitrate 250000
>     $ ifconfig can0 up
The above commands failed.

[root@localhost can]# 
[root@localhost can]# canconfig can0 bitrate 250000
opening CAN interface 'can0' in sysfs failed, maybe not a CAN interface
No such file or directory


[root@localhost ~]# ifconfig can0 up
SIOCSIFFLAGS: Invalid argument
[root@localhost ~]# 


Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

