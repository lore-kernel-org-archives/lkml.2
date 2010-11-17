Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934735Ab0KQMX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:23:58 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38547 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934606Ab0KQMX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:23:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=WobFBkna40hR+26p5R2UZjRfIDFNYnK3SeAgfdUtz/SftMwvSFGn6BH/lVGjW2+GKc
         Ebpp7WPhDquafhG0p6NqI9nTUdtsp1qZIQPSvFA5+c0aOauKajUva2AX9WTjXu+k62a3
         76gV2nSOOvz5gqN2IcsQQyQn7B01gT+Q5DK+0=
MIME-Version: 1.0
Date: Wed, 17 Nov 2010 14:23:56 +0200
Message-ID: <AANLkTinyLQUN6fMwWQDxvPpfRTo-4kHPVsggPSoAGhv-@mail.gmail.com>
Subject: make xconfig broken on 2.6.37-rc2
From: Ameya Palande <2ameya@gmail.com>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When I try to do "make xconfig" on 2.6.37-rc2 it gives me following error:

  HOSTCXX scripts/kconfig/qconf.o
In file included from scripts/kconfig/qconf.cc:48:
scripts/kconfig/qconf.moc:13: fatal error: private/qucomextra_p.h: No
such file or directory
compilation terminated.
make[1]: *** [scripts/kconfig/qconf.o] Error 1
make: *** [xconfig] Error 2

My host is ubuntu 10.10 x86-32 with libqt3 and libqt4 both installed.

Cheers,
Ameya.
