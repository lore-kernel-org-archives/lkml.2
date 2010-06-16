Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab0FPXBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 19:01:47 -0400
Received: from n20.bullet.mail.ukl.yahoo.com ([87.248.110.137]:37528 "HELO
	n20.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755024Ab0FPXBp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 19:01:45 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 48507.84373.bm@omp101.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=I8qrRcMj3+nTIdcrmzsSlhI1SszUHHG+sfM6LvcWCZXqQmK/LG7LTABYQOAUmVY0pIxFvsb1z0QrCxDoBW72F1nT9i2afZviKsBd7owWoeGt0FNF62u78Sy7BIUsOe7fZkmZPMlPZokLuP+51CXX9/Z5xiKZE+43jGtA6/xEFWY=;
Message-ID: <868976.42022.qm@web23602.mail.ird.yahoo.com>
X-YMail-OSG: 137.uKYVM1lDxQEjeRBl08dM_BFexoi5uQqjuPh8pcAKR4Y
 yq8P6nTS4uUN2qJhDb1dzupVr1DaFaONCDOLcTKZH9XB4_Ik.bUWX9uvxTFr
 fvdukPT8A6YnqONwmSan7_lEWYK4jKQDxL.q53SMx.TUAEyl.Y0.ZtCeTggp
 VIoFzc23hcvQFKU6BAda.jdmjz2Nv8dg7rew1wKxh.PA5KZdajmBVvmTUt1c
 pO42SUx7zh8XiZNQYo32D1A6ShH5hk9MkTl7HW6c9fpamea4jnT5R.7zQSkv
 ZP_.MAa_20BUqexQCu_q72zIzaDEH.tXv6wGU4PI-
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.103.269680
Date: Wed, 16 Jun 2010 23:01:43 +0000 (GMT)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: [announce] gujin gpl bootloader version 2.8.2
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a new version v2.8.2 of the Gujin bootloader at

http://gujin.org and sourceforge with bugfixes and improvements, and

Debian/Fedora packages for easy installation on i386/amd64 PC. 



The major improvements are the possibility to review/edit the final

command line of the Linux kernel when selecting by Shift-F1..Shift-F12

or holding the shift key when selecting with the mouse; recognition

of Rock Ridge on ISO9660, and the direct booting of unmodified live

CDROM images stored in /boot or in the top-level of a partition by

automagically adding one of:

"from=" for CD images with label "NimbleX*"

"fromiso=" for CD images with label "sidux*" and "Elive*"

"root=live:LABEL=...:/" for CD images with label "Fedora*", "F1*",

                               "rhel*", "CentOS*"

"iso-scan/filename=" for any other (debian/ubuntu derivatives)



The correct commandline for those live CD images is provided

by a "distributed" file named "gujin.cmd" (i.e. all files found

with this name are concat'ed and then treated), a real world example

is in the source and install archive.

It would be nice if live-cdrom author would create a file

named gujin.cmd in the directory of the kernel containing:

::vmlinu*:initr*::name to appear on Gujin menu:essential command line parameters

::vmlinu*:initr*::alternative name:alternative parameters



The file "changelog.wri" in the source archive describes many other

modifications, fixing a lot of bugs.



Downloads at:

http://sourceforge.net/projects/gujin/files/



Have fun,

Etienne. 




      

