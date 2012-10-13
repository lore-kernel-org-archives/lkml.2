Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab2JMJqq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 05:46:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40187 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2JMJqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 05:46:44 -0400
Message-ID: <50793880.2040006@suse.cz>
Date: Sat, 13 Oct 2012 11:46:40 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0a2
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Jeff Mahoney <jeffm@suse.com>, stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: 3.6.2 causes build errors again [was: master/i586/desktop: BUILD
 FAILED]
X-Enigmail-Version: 1.5a1pre
X-Forwarded-Message-Id: 
Content-Type: multipart/mixed;
 boundary="------------040001000609010405080805"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040001000609010405080805
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

This one recurred :(.

Why was the dependency added by:
commit 24cc7fb69a5b5edfdff1d38c6a213d6a33648829
Author: Jeff Mahoney <jeffm@suse.de>
Date:   Thu Sep 20 10:28:45 2012 -0400

    x86/kbuild: archscripts depends on scripts_basic

removed in this commit upstream:
commit fe04ddf7c2910362f3817c8156e41cbd6c0ee35d
Author: Michal Marek <mmarek@suse.cz>
Date:   Tue Sep 25 16:03:03 2012 +0200

    kbuild: Do not package /boot and /lib in make tar-pkg

??

(It came to us via 3.6.2 as 4bb50fa92f0).

-------- Original message --------
PYedmt: [cvs build] master/i586/desktop: BUILD FAILED (798d597e)
Datum: Sat, 13 Oct 2012 10:15:03 +0200 (CEST)
Od: XXX
Komu: XXX
Kopie: jslaby@suse.cz

Full log: XXX

Recent changes:

commit 798d597ed7ecd9fc52366a177721c544dfb7edf9
Author: Jiri Slaby <jslaby@suse.cz>
Date:   Sat Oct 13 00:30:32 2012 +0200

    Linux 3.6.2.

Possible causes:
  HOSTCC  scripts/basic/fixdep
/bin/sh: scripts/basic/fixdep: Permission denied
make[3]: *** [arch/x86/tools/relocs] Error 1
make[2]: *** [archscripts] Error 2
make[2]: *** Waiting for unfinished jobs....
make[2]: *** wait: No child processes.  Stop.
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

Last output:
++ HOST_EXTRACFLAGS='-include
/home/abuild/rpmbuild/SOURCES/host-memcpy-hack.h'
+ test -e
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.6.2/kabi/i386/symtypes-desktop
+ true
+ make -j32 all CONFIG_DEBUG_SECTION_MISMATCH=y
+ tee buildlog
make[3]: Nothing to be done for `all'.
  HOSTCC  arch/x86/tools/relocs
  GEN
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.6.2/linux-obj/Makefile
  CHK     include/linux/version.h
  HOSTCC  scripts/basic/fixdep
/bin/sh: scripts/basic/fixdep: Permission denied
make[3]: *** [arch/x86/tools/relocs] Error 1
make[2]: *** [archscripts] Error 2
make[2]: *** Waiting for unfinished jobs....
make[2]: *** wait: No child processes.  Stop.
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2
+ test 2 -eq 0
+ test 00 -gt 0
+ exit 1
error: Bad exit status from /var/tmp/rpm-tmp.xSfzzB (%build)


RPM build errors:
    Bad exit status from /var/tmp/rpm-tmp.xSfzzB (%build)




--------------040001000609010405080805
Content-Type: text/plain; charset=UTF-8;
 name="=?UTF-8?B?xIzDoXN0IHDFmWlwb2plbsOpIHpwcsOhdnk=?="
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0*=UTF-8''%C4%8C%C3%A1%73%74%20%70%C5%99%69%70%6F%6A%65%6E%C3%A9;
 filename*1*=%20%7A%70%72%C3%A1%76%79


--------------040001000609010405080805--
