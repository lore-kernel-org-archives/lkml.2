Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab1FDOMH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 10:12:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34797 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab1FDOMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 10:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=GnqnHN6TRTgzQuc0L7EWcKIEnSnJ1jdaYglcpum9eMbg7Ly3IOOBMObC6g/rBKVn/O
         WlYiOPEX4ZJldGE1NfIg9KNgR4BoEUyDgjCBSTxk+Pp8b2TRtiHwLU1RhJ61cj1EdUiP
         YozqGyt8zzZJ2EjQbCp9g1XbOy+dauSEpjvBA=
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Sat, 4 Jun 2011 22:11:22 +0800
Message-ID: <BANLkTinNKg1KMB13DChOc7E9uQ+f6mZXAg@mail.gmail.com>
Subject: Get new GDB for UBUNTU from launchpad PPA
To: gdb@sourceware.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello every GDB and UBUNTU user,

Maybe you still use old version GDB like 7.2 or early version, but it
have a lot of bugs and maybe miss some feature that you really want
but just included in new version.
Or maybe you are working on some different arch like ARM or MIPS, you
will need rebuild a GDB for this arch.

I begin to publish new version GDB (7.3 and 7.3.5) for UBUNTU 10.04,
10.10, 11.04, 11.10 (Still working on 8.04) in launchpad PPA.
These GDB is:
1.  GDB maintainer are working on them everyday.  You can get the new
feature and bug fix early.
2.  All of them are built by "--enable-targets=all
--enable-64-bit-bfd".  So all of them support all arch that GDB
support.  You can debug the local program or debug the remote program
of other arch inside it.
3.  The package is named "gdb-7.3" and "gdb-trunk", and the GDB that
installed to the system is named "gdb-7.3" and "gdb-7.3.5".  So it
will not affect the GDB that you install in before.  You can use the
old one directly if you got some trouble with the new one.

Please goto following URL to get them:
https://launchpad.net/~teawater/+archive/gdb-10.04
https://launchpad.net/~teawater/+archive/gdb-10.10
https://launchpad.net/~teawater/+archive/gdb-11.04
https://launchpad.net/~teawater/+archive/gdb-11.10

Thanks,
Hui
