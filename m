Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab0FDDK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 23:10:29 -0400
Received: from clueserver.org ([65.102.45.174]:36504 "EHLO clueserver.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180Ab0FDDK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 23:10:28 -0400
X-Greylist: delayed 625 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jun 2010 23:10:28 EDT
Date: Thu, 3 Jun 2010 20:00:02 -0700 (PDT)
From: alan <alan@clueserver.org>
X-X-Sender: alan@blackbox.fnordora.org
To: linux-kernel@vger.kernel.org
Subject: modpost segfaults with 32bit compile on 64 bit version of Fedora 13
Message-ID: <Pine.LNX.4.64.1006031952370.30918@blackbox.fnordora.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have reported this to the Fedora bugzilla. Not getting much traction on 
the problem. Maybe someone here has an idea.

I have a x86_64 version of Fedora 13. I try and build a kernel under i386 
and modpost segfaults every time. (Works fine on Fedora 12 and gcc 4.4.3.)

It does not matter if I use "make ARCH=x86", i386 and make, or any other 
32 bit compile I have tried.

Here is the gcc info:

gcc -v
Using built-in specs.
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man 
--infodir=/usr/share/info 
--with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap 
--enable-shared --enable-threads=posix --enable-checking=release 
--with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions 
--enable-gnu-unique-object 
--enable-languages=c,c++,objc,obj-c++,java,fortran,ada 
--enable-java-awt=gtk --disable-dssi 
--with-java-home=/usr/lib/jvm/java-1.5.0-gcj-1.5.0.0/jre 
--enable-libgcj-multifile --enable-java-maintainer-mode 
--with-ecj-jar=/usr/share/java/eclipse-ecj.jar --disable-libjava-multilib 
--with-ppl --with-cloog --with-tune=generic --with-arch_32=i686 
--build=x86_64-redhat-linux
Thread model: posix
gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC)

This works under Fedora 12, but not under 13 with the exact same code and 
commands. I have tested with 2.6.35-rc1, as well as other versions.

Any idea what they mangled in gcc 4.4.4 to cause this? So far the Fedora 
people have claimed "it is a kernel problem".

Thanks.

-- 
Truth is stranger than fiction because fiction has to make sense.
